class SessionAssignmentsController < ResourceController
  SERIALIZER_CLASS = 'SessionAssignmentSerializer'.freeze
  POLICY_CLASS = 'SessionAssignmentPolicy'.freeze
  POLICY_SCOPE_CLASS = 'SessionAssignmentPolicy::Scope'.freeze

  def unexpress_interest
    model_class.transaction do
      authorize @object, policy_class: policy_class
      # if there is a session assignment set interested to false
      @object.update(
        interested: false,
        interest_ranking: nil,
        interest_notes: nil,
        interest_role: nil
      )
      @object.save!

      render_object(@object)
    end
  end

  def update_actions
    [:update, :unexpress_interest]
  end

  def serializer_includes
    [
      :person,
      :session,
      :'session.format'
    ]
  end

  def includes
    [
      :session
    ]
  end

  def belongs_to_param_id
    params[:session_id]
  end

  def belong_to_class
    Session
  end

  def belongs_to_relationship
    'session_assignments'
  end

  def paginate
    false
  end

end
