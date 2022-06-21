class SessionAssignmentsController < ResourceController
  SERIALIZER_CLASS = 'SessionAssignmentSerializer'.freeze
  POLICY_CLASS = 'SessionAssignmentPolicy'.freeze
  POLICY_SCOPE_CLASS = 'SessionAssignmentPolicy::Scope'.freeze

  def unexpress_interest
    model_class.transaction do
      authorize @object, policy_class: policy_class
      # if there is a session assignment set interested to false
      person = Person.find params[:person_id] if params[:person_id]
      person ||= current_person

      raise "Person and assignment do not match for removing interest" if person.id != @object.person_id

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
    if params[:session_id]
      # remove included data for now to speed up loads
      # if we are asking with a session id then we just need the other parts
      [
        :person
      ]
    else
      [
        :person,
        :session,
        :'session.format'
      ]
    end
  end

  def includes
    [
      :person,
      :session
    ]
  end

  def references
    [
      :person,
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

  def allowed_params
    %i[
      id
      lock_version
      interest_notes
      interest_ranking
      interest_role
      interested
      person_id
      planner_notes
      session_assignment_role_type_id
      session_id
      sort_order
      state
      visibility
    ]
  end

end
