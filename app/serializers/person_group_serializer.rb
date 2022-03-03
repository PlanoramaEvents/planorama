class PersonGroupSerializer
  include JSONAPI::Serializer

  attributes :group, :id

  belongs_to :person,
    links: {
      self: -> (object, params) {
        "#{params[:domain]}/person_group/#{object.id}"
      },
      related: -> (object, params) {
        "#{params[:domain]}/person/#{object.person_id}"
      }
    }
end
