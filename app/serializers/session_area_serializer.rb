# == Schema Information
#
# Table name: session_areas
#
#  id           :uuid             not null, primary key
#  lock_version :integer
#  primary      :boolean
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  area_id      :uuid
#  session_id   :uuid
#
# Indexes
#
#  index_session_areas_on_session_id_and_area_id  (session_id,area_id) UNIQUE
#
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
