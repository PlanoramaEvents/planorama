class Conflicts::AvailabilityConflictSerializer
  include JSONAPI::Serializer

  attributes :person_id, :session_id, :session_assignment_id

  belongs_to :session_assignment, serializer: SessionAssignmentSerializer
  belongs_to :person, serializer: PersonSerializer
  belongs_to :session,  serializer: SessionSerializer
end
