class Survey::ReportConfigPolicy < PlannerPolicy
  class Scope < PlannerPolicy::Scope
    def resolve
      if allowed?(action: :index)
        scope.all
      end
    end
  end
end