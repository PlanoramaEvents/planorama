class ScheduleSnapshotsController < ResourceController
  SERIALIZER_CLASS = 'ScheduleSnapshotSerializer'.freeze
  POLICY_CLASS = 'ScheduleSnapshotPolicy'.freeze
  POLICY_SCOPE_CLASS = 'ScheduleSnapshotPolicy::Scope'.freeze

  # def paginate
  #   false
  # end
end
