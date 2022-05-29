class Conflicts::AvailabilityConflictsController < ResourceController
  MODEL_CLASS = 'Conflicts::AvailabilityConflict'.freeze
  SERIALIZER_CLASS = 'Conflicts::AvailabilityConflictSerializer'.freeze
  # POLICY_CLASS = 'AvailabilityConflictsPolicy'.freeze

  def serializer_includes
    [
      :person,
      :session_assignment
      # :session,
    ]
  end
end
