class RoomSetPolicy < PlannerPolicy
  class Scope < PlannerPolicy::Scope
    def resolve
      scope.all
    end
  end
end
