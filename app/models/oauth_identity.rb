class OauthIdentity < ApplicationRecord
  belongs_to :person, optional: true

  def self.from_omniauth(provider:, details:)
    reg_id = details['id']

    OauthIdentity.transaction do
      identity = OauthIdentity.find_or_create_by(provider: provider, reg_id: reg_id) do |iden|
                  iden.email = details['email'].downcase.strip
                end

      # Make sure reg number and raw info has the latest data
      identity.reg_number = details['ticket_number']
      identity.raw_info = details
      identity.save!

      person = identity.person

      if !person
        addr = EmailAddress.find_by(email: identity.email, isdefault: true)
        person = if addr && addr.person
                    addr.person
                  else
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
                            isdefault: true
                          }
                        ]
                      )
                  end
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
