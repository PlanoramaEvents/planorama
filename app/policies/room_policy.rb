class RoomPolicy < PlannerPolicy
  def index?
    false
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
