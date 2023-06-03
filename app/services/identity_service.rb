module IdentityService
  def self.from_clyde(auth_info:)
    credentials = auth_info[:credentials]
    # Get Participant Details
    # TODO: maybe we want to pass refresh token, but time should not be that long...
    svc = ClydeService.get_svc(token: credentials[:token])
    details = svc.me

    # Create or find the Identity
    # associate with Person and authenticate
    create_identity_from_clyde(details: details['data'])
  end

  # Given the OAuth into find or create the identity
  def self.find_or_create_identity(provider:, reg_id:, reg_number:, email:, raw_info:)
    identity = OauthIdentity.find_or_create_by(provider: provider, reg_id: reg_id) do |iden|
            iden.email = email.downcase.strip if email && !email.blank?
          end

    # Make sure reg number and raw info has the latest data
    identity.reg_number = reg_number
    identity.raw_info = raw_info
    identity.save!

    identity
  end

  def self.create_person_from_clyde(details:, identity:, email_is_default: true)
    fullname = details['full_name'].strip unless details['full_name']&.strip.blank?
    preferred_name = details['preferred_name'].strip unless details['preferred_name']&.strip.blank?
    Person.create!(
      name: fullname,
      name_sort_by: fullname,
      pseudonym: preferred_name,
      pseudonym_sort_by: preferred_name,
      password: (0...50).map { ('a'..'z').to_a[rand(26)] }.join,
      email_addresses_attributes: [
        {
        email: identity.email,
        isdefault: email_is_default
        }
      ]
    )
  end

  def self.create_identity_from_clyde(details:)
    reg_id = details['id']

    OauthIdentity.transaction do
      identity = find_or_create_identity(
                   provider: 'clyde',
                   reg_id: reg_id,
                   reg_number: details['ticket_number'],
                   email: details['email'],
                   raw_info: details
                 )
      person = identity.person

      if !person
        addr = EmailAddress.find_by(email: identity.email, isdefault: true)

        # if there is a person with this as primary emaail AND no OAuth Clyde identity
        person = if addr && addr.person
                   addr.person if addr.person.oauth_identities.where(provider: 'clyde').count == 0
                 end

        # Otherwise we create a new person, if the email is already used as prime we can not set it as the default
        person ||= create_person_from_clyde(details: details, identity: identity, email_is_default: addr.nil?)                 

        identity.person = person
        identity.save!
      end

      # Attending status does not map well
      # person.attendance_type = details[:attending_status]
      person.registration_number = details['ticket_number']
      # person.registration_type = details[:product]
      person.registered = true # TODO: only registered people have clyde ids ....
      person.save!

      identity
    end
  end
end
