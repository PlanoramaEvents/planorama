class SessionsController < ResourceController
  SERIALIZER_CLASS = 'SessionSerializer'.freeze
  POLICY_CLASS = 'SessionPolicy'.freeze
  POLICY_SCOPE_CLASS = 'SessionPolicy::Scope'.freeze
  # DEFAULT_SORTBY = 'name_sort_by'
# TBD

  def serializer_includes
    [
      :format
    ]
  end

  def includes
    [
      :format
    ]
  end

  def references
    [
      :format
    ]
  end

  def allowed_params
    %i[
      id
      lock_version
      format_id
      title
      description
    ]
  end
end
