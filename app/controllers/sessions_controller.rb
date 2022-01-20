class SessionsController < ResourceController
  SERIALIZER_CLASS = 'SessionSerializer'.freeze
  POLICY_CLASS = 'SessionPolicy'.freeze
  POLICY_SCOPE_CLASS = 'SessionPolicy::Scope'.freeze
  # DEFAULT_SORTBY = 'name_sort_by'
# TBD
end
