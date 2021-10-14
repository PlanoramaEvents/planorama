class PersonRoleSerializer
  include JSONAPI::Serializer

  attributes :role, :id

  belongs_to :person,
    links: {
      self: -> (object, params) {
        "#{params[:domain]}/person_roles/#{object.id}"
      },
      related: -> (object, params) {
        "#{params[:domain]}/people/#{object.person_id}"
      }
    }
end
