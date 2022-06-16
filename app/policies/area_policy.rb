class AreaPolicy < PlannerPolicy
  def index?
    true
  end

  def show?
    true
  end

  class Scope < PlannerPolicy::Scope
    def resolve
      scope.all
    end
  end
end
