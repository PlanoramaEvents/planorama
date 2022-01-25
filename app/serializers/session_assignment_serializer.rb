class SessionAssignmentSerializer
  include JSONAPI::Serializer

  attributes :id, :lock_version, :created_at, :updated_at,
             :person_id, :session_id, :sort_order, :session_assignment_role_type_id,
             :visibility, :state, :planner_notes,
             :interested, :interest_ranking, :interest_notes, :interest_role

end
