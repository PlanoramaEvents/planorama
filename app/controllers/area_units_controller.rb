class AreaUnitsController < ResourceController
  SERIALIZER_CLASS = 'AreaUnitSerializer'.freeze
  POLICY_CLASS = 'AreaUnitsPolicy'.freeze
  POLICY_SCOPE_CLASS = 'AreaUnitsPolicy::Scope'.freeze

  def paginate
    false
  end
end
