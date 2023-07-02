class IntegrationPolicy < PlannerPolicy
  def publish?
    allowed?(action: :publish)
  end

  def airmeet?
    allowed?(action: :airmeet)
  end

  def clyde?
    allowed?(action: :clyde)
  end

  def update?
    allowed?(action: :update)
  end

  class Scope < PlannerPolicy::Scope
    def resolve
      scope.all
    end
  end
end
