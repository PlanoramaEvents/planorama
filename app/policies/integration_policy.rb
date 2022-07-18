class IntegrationPolicy < PlannerPolicy
  def publish?
    allowed?(action: :publish)
  end

  class Scope < PlannerPolicy::Scope
    def resolve
      scope.all
    end
  end
end
