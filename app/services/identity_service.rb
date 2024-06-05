require "securerandom"

module IdentityService
  def self.from_clyde(auth_info:, current_person:)
    credentials = auth_info[:credentials]
    # Get Participant Details
    # TODO: maybe we want to pass refresh token, but time should not be that long...
    svc = ClydeService.get_svc(token: credentials[:token])
    details = svc.me

    # Create or find the Identity
    # associate with Person and authenticate
    if current_person
      associate_identity_from_clyde(details: details['data'], current_person: current_person)
    else
      create_identity_from_clyde(details: details['data'])
    end
  end

  def self.find_identity(provider:, reg_id:, reg_number:)
    # Find identity by reg id
    identity = OauthIdentity.find_by("provider = ? and reg_id = '?'", provider, reg_id)
    # If not found use reg number cause that is supposed to be invariant as well
    identity ||= OauthIdentity.find_by("provider = ? and reg_number = ?", provider, reg_number)

    identity
  end

  def self.create_identity(provider:, reg_id:, reg_number:)
    # If not found then create a new identity
    OauthIdentity.new(
      provider: provider, reg_id: reg_id, reg_number: reg_number
    )
  end

  def self.update_identity(identity:, reg_id:, reg_number:, email:, raw_info:)
    # If not found then create a new identity
    identity.email = email if identity.email != email
    identity.reg_id = reg_id if identity.reg_id != reg_id
    identity.reg_number = reg_number if identity.reg_number != reg_number
    identity.raw_info = raw_info
    identity.save!

    identity
  end

  def self.find_or_create_identity(provider:, reg_id:, reg_number:, email:, raw_info:)
    identity = find_identity(provider: provider, reg_id: reg_id, reg_number: reg_number)
    # If not found then create a new identity
    identity ||= create_identity(provider: provider, reg_id: reg_id, reg_number: reg_number)
    # Make sure reg number and raw info has the latest data
    update_identity(identity: identity, reg_id: reg_id, reg_number: reg_number, email: email, raw_info: raw_info)
  end

  def self.create_person_from_clyde(details:, identity:, email_is_default: true)
    fullname = details['full_name'].strip unless details['full_name']&.strip.blank?
    preferred_name = details['preferred_name'].strip unless details['preferred_name']&.strip.blank?

    email_attrs = [{ email: identity.email, isdefault: email_is_default }] if identity.email
    person = Person.create!(
                name: fullname,
                name_sort_by: fullname,
                pseudonym: preferred_name,
                pseudonym_sort_by: preferred_name,
                # We do not want to create a person with a blank password
                # also it is not allowed to be NULL in the db
                password: SecureRandom.uuid,
                email_addresses_attributes: email_attrs
              )
    # Add participant role to the person
    ConventionRole.create(
      person: person,
      role: ConventionRole.roles[:participant]
    )
    person
  end

  def self.associate_identity_from_clyde(details:, current_person:)
    reg_id = details['id']
    reg_number = details['ticket_number']
    email = details['email']

    OauthIdentity.transaction do
      OauthIdentity.with_advisory_lock("Identity_clyde_#{reg_id}_lock", timeout_seconds: 60) do
        # Ensure not already associated ... if they are check that it is the same
        identity = find_identity(provider: 'clyde', reg_id: reg_id, reg_number: reg_number)

        if identity
          raise Exceptions::AuthError.new("Identity already associated with another person", "101") if identity.person_id != current_person.id
        end

        identity ||= create_identity(provider: 'clyde', reg_id: reg_id, reg_number: reg_number)
        identity.person = current_person
        identity.save!

        update_identity(identity: identity, reg_id: reg_id, reg_number: reg_number, email: email, raw_info: details)
        update_reg_info(person: current_person, details: details)
      end
    end
  end

  # Clear any linkage to reg for the person
  def self.clear_person_reg_info(person:)
    person.reg_id = nil
    person.registration_type = nil
    person.registered = false
    person.registration_number = nil
    person.reg_attending_status = nil
    person.date_reg_synced = Time.now
  end

  def self.update_reg_info(person:, details:, reg_match: Person.reg_matches[:self])
    # If the Ticket Numbers do not match then we reset cause there may be an issue
    if person.registration_number && person.registration_number != details['ticket_number']
      clear_person_reg_info(person: person)
    # If the Reg numbers do not match then we reset cause there may be an issue
    elsif person.reg_id && person.reg_id != details['id'].to_s
      clear_person_reg_info(person: person)
    else
      person.reg_id = details['id'] unless person.reg_id
      person.registration_number = details['ticket_number'] unless person.registration_number
      # Based on the products that they have
      person.registration_type = details['product']
      person.registered = details['attending_status'] != 'Not Attending'
      person.reg_attending_status = details['attending_status']
      # Need to store time of last sync
      # How the registration match was done
      person.reg_match = reg_match

      # This will ensure update is done only any of the reg data has changed
      if person.changed?
        person.date_reg_synced = Time.now
      end
      # Attendance type in Plano is one of
      # in_person, hybrid, virtual
      # Clyde does not map to these well. Recommend that we get this from survey and Person profile
      # in Plano instead.
      # person.attendance_type = 
    end
    person.changed? ? person.save! : false
  end

  def self.create_identity_from_clyde(details:)
    reg_id = details['id']

    OauthIdentity.transaction do
      OauthIdentity.with_advisory_lock("Identity_clyde_#{reg_id}_lock", timeout_seconds: 60) do
        identity = find_or_create_identity(
                    provider: 'clyde',
                    reg_id: reg_id,
                    reg_number: details['ticket_number'],
                    email: details['email'],
                    raw_info: details
                  )
        person = identity.person

        if !person
          # Find person by their default email
          addr = EmailAddress.find_by(email: identity.email, isdefault: true)

          # if there is a person with this as primary email AND no OAuth Clyde identity
          # then we will error out - as they should login with Plano and link instead
          raise Exceptions::AuthError.new("Person already exists with that email", "102") if addr

          # Otherwise we create a new person, if the email is already used as prime we can not set it as the default
          person = create_person_from_clyde(details: details, identity: identity)                 

          # And associate them with the Clyde Identity
          identity.person = person
          identity.save!
        end

        update_reg_info(person: person, details: details)

        identity
      end
    end
  end
end
