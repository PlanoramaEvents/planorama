class PersonScheduleApprovalsController < ResourceController
  SERIALIZER_CLASS = 'PersonScheduleApprovalSerializer'.freeze
  POLICY_CLASS = 'PersonScheduleApprovalPolicy'.freeze
  POLICY_SCOPE_CLASS = 'PersonScheduleApprovalPolicy::Scope'.freeze

  # we need a fetch that does it by person and workflow
  def fetch
    model_class.transaction do
      authorize model_class, policy_class: policy_class

      person = Person.find params[:person_id] if params[:person_id]
      workflow = ScheduleWorkflow.find params[:workflow_id]
      person ||= current_person

      raise 'missing workflow' unless workflow

      approval = PersonScheduleApproval.find_or_create_by(
        person_id: person.id,
        schedule_workflow_id: workflow.id
      )

      render_object(
        approval,
        serializer: PersonScheduleApprovalSerializer,
        jsonapi_included: []
      )
    end
  end

  # Approve a specific workflow
  def approve
    model_class.transaction do
      authorize model_class, policy_class: policy_class

      person = Person.find params[:person_id] if params[:person_id]
      workflow = ScheduleWorkflow.find params[:workflow_id]
      person ||= current_person

      raise 'missing workflow' unless workflow

      approval = PersonScheduleApproval.find_or_create_by(
        person_id: person.id,
        schedule_workflow_id: workflow.id
      )

      permitted = params.permit(:comments, :approved)
      approval.update(
        permitted
        # comments: params[:workflow_id],
        # approved: params[:approved]
      )

      render_object(
        approval,
        serializer: PersonScheduleApprovalSerializer,
        jsonapi_included: []
      )
    end
  end

  def allowed_params
    %i[
      id
      lock_version
      person_id
      workflow_id
      comments
      approved
    ]
  end
end
