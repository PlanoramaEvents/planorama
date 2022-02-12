class SessionAssignmentsController < ResourceController
  SERIALIZER_CLASS = 'SessionAssignmentSerializer'.freeze
  POLICY_CLASS = 'SessionAssignmentPolicy'.freeze
  POLICY_SCOPE_CLASS = 'SessionAssignmentPolicy::Scope'.freeze

  def serializer_includes
    [
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
