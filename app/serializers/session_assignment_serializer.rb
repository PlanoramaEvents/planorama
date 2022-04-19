class SessionAssignmentSerializer
  include JSONAPI::Serializer

  attributes :id, :lock_version, :created_at, :updated_at,
             :person_id, :session_id, :sort_order, :session_assignment_role_type_id,
             :visibility, :state, :planner_notes,
             :interested, :interest_ranking, :interest_notes, :interest_role

  belongs_to :person,
             if: Proc.new { |record| record.session },
             links: {
               self: -> (object, params) {
                 "#{params[:domain]}/session_assignment/#{object.id}"
               },
               related: -> (object, params) {
                 "#{params[:domain]}/person/#{object.person.id}"
               }
             }

  belongs_to :session,
             if: Proc.new { |record| record.session },
             links: {
               self: -> (object, params) {
                 "#{params[:domain]}/session_assignment/#{object.id}"
               },
               related: -> (object, params) {
                 "#{params[:domain]}/session/#{object.session.id}"
               }
             }
end
