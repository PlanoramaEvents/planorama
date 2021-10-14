class EmailAddressSerializer
  include JSONAPI::Serializer

  attributes :email, :id, :isdefault, :lock_version

  belongs_to :person,
    links: {
      self: -> (object, params) {
        "#{params[:domain]}/email_addresses/#{object.id}"
      },
      related: -> (object, params) {
        "#{params[:domain]}/people/#{object.person_id}"
      }
    }
end
