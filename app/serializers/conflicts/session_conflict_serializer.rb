# == Schema Information
#
# Table name: session_conflicts
#
#  conflict_session_assignment_name         :text
#  conflict_session_duration                :integer
#  conflict_session_start_time              :datetime
#  conflict_session_title                   :string
#  conflict_type                            :text
#  person_name                              :string
#  person_published_name                    :string
#  session_assignment_name                  :string
#  session_duration                         :integer
#  session_start_time                       :datetime
#  session_title                            :string(256)
#  conflict_id                              :text             primary key
#  conflict_session_assignment_role_type_id :uuid
#  conflict_session_id                      :uuid
#  person_id                                :uuid
#  room_id                                  :uuid
#  session_assignment_id                    :uuid
#  session_assignment_role_type_id          :uuid
#  session_id                               :uuid
#
class Conflicts::SessionConflictSerializer
  include JSONAPI::Serializer

  attribute :id, :person_id, :person_name, :person_published_name,
            :session_assignment_id,
            :session_id, :session_title, :session_start_time,
            :conflict_session_id, :conflict_session_title,
            :room_id,
            :conflict_type

  attribute :room_name do |record|
    record.room ? record.room.name : ''
  end

  has_one :room, lazy_load_data: true, serializer: ::RoomSerializer,
          if: Proc.new { |record| record.room },
          links: {
            related: -> (object, params) {
              "#{params[:domain]}/room/#{object.room.id}"
            }
          }

  has_one :session, lazy_load_data: true, serializer: ::SessionSerializer,
          if: Proc.new { |record| record.session },
          links: {
            related: -> (object, params) {
              "#{params[:domain]}/session/#{object.session_id}"
            }
          }

  has_one :conflict_session, lazy_load_data: true, serializer: ::SessionSerializer,
          if: Proc.new { |record| record.conflict_session },
          links: {
            related: -> (object, params) {
              "#{params[:domain]}/session/#{object.conflict_session_id}"
            }
          }

  has_one :person, lazy_load_data: true, sserializer: ::PersonSerializer,
          if: Proc.new { |record| record.person },
          links: {
            related: -> (object, params) {
              "#{params[:domain]}/person/#{object.person_id}"
            }
          }

  has_one :session_assignment, lazy_load_data: true, sserializer: ::SessionAssignmentSerializer,
          if: Proc.new { |record| record.session_assignment },
          links: {
            related: -> (object, params) {
              "#{params[:domain]}/session_assignment/#{object.session_assignment_id}"
            }
          }
end
