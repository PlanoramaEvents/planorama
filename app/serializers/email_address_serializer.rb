class EmailAddressSerializer
  include JSONAPI::Serializer

  attributes :email, :id, :isdefault, :lock_version

  belongs_to :person,
    if: Proc.new { |record| record.person_id },
    links: {
      self: -> (object, params) {
        "#{params[:domain]}/email_address/#{object.id}"
      },
      related: -> (object, params) {
        "#{params[:domain]}/person/#{object.person_id}"
      }
    }
end
