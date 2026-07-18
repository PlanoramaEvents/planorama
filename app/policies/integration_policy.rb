class IntegrationPolicy < PlannerPolicy
  def publish?
    allowed?(action: :publish)
  end

  def airmeet?
    allowed?(action: :airmeet)
  end

  def registration?
    allowed?(action: :registration)
  end

  def g24rce?
    allowed?(action: :g24rce)
  end

  def zoom?
    allowed?(action: :zoom)
  end

  def portal?
    allowed?(action: :portal)
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
