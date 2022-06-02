class LinearUnitsController < ResourceController
  SERIALIZER_CLASS = 'LinearUnitSerializer'.freeze
  POLICY_CLASS = 'LinearUnitsPolicy'.freeze
  POLICY_SCOPE_CLASS = 'LinearUnitsPolicy::Scope'.freeze

  def paginate
    false
  end
end
