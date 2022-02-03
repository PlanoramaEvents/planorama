class SessionAreaSerializer
  include JSONAPI::Serializer

  attributes :id, :area_id, :session_id

  belongs_to :area
  belongs_to :session
    # links: {
    #   self: -> (object, params) {
    #     "#{params[:domain]}/session_role/#{object.id}"
    #   },
    #   related: -> (object, params) {
    #     "#{params[:domain]}/person/#{object.person_id}"
    #   }
    # }
end
