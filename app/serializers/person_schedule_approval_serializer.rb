class PersonScheduleApprovalSerializer
  include JSONAPI::Serializer

  attributes :id, :lock_version, :created_at, :updated_at,
             :comments,
             :approved, :person_id, :schedule_workflow_id

  attribute :workflow_state do |obj|
    obj.schedule_workflow&.state
  end

  has_one :schedule_workflow, lazy_load_data: true, serializer: ScheduleWorkflowSerializer,
          links: {
           self: -> (object, params) {
             "#{params[:domain]}/person_schedule_approval/#{object.id}"
           },
           related: -> (object, params) {
             "#{params[:domain]}/schedule_workflow/#{object.schedule_workflow_id}"
           }
         }

end
