class PersonRoleSerializer
  include JSONAPI::Serializer

  attributes :role, :id

  belongs_to :person,
    links: {
      self: -> (object, params) {
        "#{params[:domain]}/person_role/#{object.id}"
      },
      related: -> (object, params) {
        "#{params[:domain]}/person/#{object.person_id}"
      }
    }
end
