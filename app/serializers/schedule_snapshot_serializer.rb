class ScheduleSnapshotSerializer
  include JSONAPI::Serializer

  attributes :id, :lock_version, :created_at, :updated_at,
             :label, :created_by, :started_at, :completed_at,
             :status
end
