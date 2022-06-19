class Survey::Page::QuestionPolicy < PlannerPolicy
  class Scope < PlannerPolicy::Scope
    def resolve
      scope.all
    end
  end
end
