class ScheduleWorkflowSerializer
  include JSONAPI::Serializer

  attributes :id, :lock_version, :created_at, :updated_at,
             :created_by, :set_at, :state

  # snapshot information
end
