class Conflicts::SessionConflictSerializer
  include JSONAPI::Serializer

  attribute :session_id, :room_id, :person_id, :session_assignment_id, :conflict_session_id, :conflict_type

  has_one :room, serializer: ::RoomSerializer,
          if: Proc.new { |record| record.room },
          links: {
            related: -> (object, params) {
              "#{params[:domain]}/room/#{object.room.id}"
            }
          }

  has_one :session, serializer: ::SessionSerializer,
          if: Proc.new { |record| record.session },
          links: {
            related: -> (object, params) {
              "#{params[:domain]}/session/#{object.session_id}"
            }
          }

  has_one :conflict_session, serializer: ::SessionSerializer,
          if: Proc.new { |record| record.conflict_session },
          links: {
            related: -> (object, params) {
              "#{params[:domain]}/session/#{object.conflict_session_id}"
            }
          }

  has_one :person, serializer: ::PersonSerializer,
          if: Proc.new { |record| record.person },
          links: {
            related: -> (object, params) {
              "#{params[:domain]}/person/#{object.person_id}"
            }
          }

  has_one :session_assignment, serializer: ::SessionAssignmentSerializer,
          if: Proc.new { |record| record.session_assignment },
          links: {
            related: -> (object, params) {
              "#{params[:domain]}/session_assignment/#{object.session_assignment_id}"
            }
          }
  # TODO: add in the other relationships when we have the other view union'd in
end

# "http://localhost:3000/session_conflict/
# "c0061547-fe5e-46be-9e1c-51a989d82c0f,00000000-0000-0000-0000-000000000002,,,availability"

# Conflicts::SessionConflict.find "c0061547-fe5e-46be-9e1c-51a989d82c0f,00000000-0000-0000-0000-000000000002,,,availability"
