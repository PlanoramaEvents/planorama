class SessionLimitsController < ResourceController
  SERIALIZER_CLASS = 'SessionLimitSerializer'.freeze
  POLICY_CLASS = 'SessionLimitsPolicy'.freeze
  POLICY_SCOPE_CLASS = 'SessionLimitsPolicy::Scope'.freeze

  def belongs_to_param_id
    params[:person_id]
  end

  def belong_to_class
    Person
  end

  def belongs_to_relationship
    'session_limits'
  end

  def allowed_params
    %i[
      lock_version
      id
      person_id
      max_sessions
      day
    ]
  end

  def paginate
    false
  end
end
