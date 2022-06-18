class Conflicts::AvailabilityConflictSerializer
  include JSONAPI::Serializer

  # attribute :id do |obj|
  #   obj.id.join(',')
  # end

  belongs_to :session_assignment, serializer: SessionAssignmentSerializer
  belongs_to :person, serializer: PersonSerializer
  belongs_to :session,  serializer: SessionSerializer
end
