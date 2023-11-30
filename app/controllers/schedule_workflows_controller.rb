class ScheduleWorkflowsController < ResourceController
  SERIALIZER_CLASS = 'ScheduleWorkflowSerializer'.freeze
  POLICY_CLASS = 'ScheduleWorkflowPolicy'.freeze
  POLICY_SCOPE_CLASS = 'ScheduleWorkflowPolicy::Scope'.freeze
  DEFAULT_SORTBY = 'schedule_workflows.updated_at'
  DEFAULT_ORDER = 'desc'

  def reset
    ScheduleWorkflow.destroy_all

    render status: :ok,
          json: { message: 'workflow reset' }.to_json,
          content_type: 'application/json'
  end

  # When we set a draft state we need to schedule the work etc
  # When we reset we need to deal with in progress
  # ie on save
  def before_save
    @snapshot = if @object.state == 'draft'
                  ScheduleSnapshot.create!(
                    label: 'draft',
                    created_by: current_person.name,
                    started_at: Time.now
                  )
               end

    @object.created_by = current_person.name
    @object.set_at = Time.now
    @object.schedule_snapshot = @snapshot
  end

  def after_save_tx
    # create the snapshot if needed
    SnapshotWorker.perform_async(@snapshot.id) if @snapshot
  end

  def paginate
    false
  end
end
