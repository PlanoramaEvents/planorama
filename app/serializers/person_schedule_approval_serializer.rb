class PersonScheduleApprovalSerializer
  include JSONAPI::Serializer

  attributes :id, :lock_version, :created_at, :updated_at,
             :comments,
             :approved, :person_id, :schedule_workflow_id
end
