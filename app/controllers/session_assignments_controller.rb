class SessionAssignmentsController < ResourceController
  SERIALIZER_CLASS = 'SessionAssignmentSerializer'.freeze
  POLICY_CLASS = 'SessionAssignmentPolicy'.freeze
  POLICY_SCOPE_CLASS = 'SessionAssignmentPolicy::Scope'.freeze

end
