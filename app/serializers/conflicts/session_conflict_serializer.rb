class Conflicts::SessionConflictSerializer
  include JSONAPI::Serializer

  attribute :person_id, :person_name, :person_published_name,
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
