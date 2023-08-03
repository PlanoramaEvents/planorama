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
          raise "Identity already associated with another person" if identity.person_id != current_person.id
        end

        identity ||= create_identity(provider: 'clyde', reg_id: reg_id, reg_number: reg_number)
        identity.person = current_person
        identity.save!

        update_identity(identity: identity, reg_id: reg_id, reg_number: reg_number, email: email, raw_info: details)
        update_reg_info(person: current_person, details: details)
      end
    end
  end

  def self.update_reg_info(person:, details:)
    person.registration_number = details['ticket_number']
    # TODO: we need to base this on the products that they have
    # which requires a change to the Clyde API to get the products for the person
    # person.registration_type = details[:product]
    # person.registered = true 
    person.save!
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
          person = if addr && addr.person
                     addr.person if addr.person.oauth_identities.where(provider: 'clyde').count == 0
                   end

          # Otherwise we create a new person, if the email is already used as prime we can not set it as the default
          person ||= create_person_from_clyde(details: details, identity: identity, email_is_default: addr.nil?)                 

          # And associate them with the Clyde Identity
          identity.person = person
          identity.save!
        end

        # Attending status does not map well - we will need Plano to ask
        # person.attendance_type = details[:attending_status]

        person.registration_number = details['ticket_number']
        # TODO: we need to base this on the products that they have
        # which requires a change to the Clyde API to get the products for the person
        # person.registration_type = details[:product]
        # person.registered = true 
        person.save!

        identity
      end
    end
  end
end
