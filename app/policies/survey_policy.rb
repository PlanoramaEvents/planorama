class SurveyPolicy < PlannerPolicy
  # Anyone can see a survey ...
  def show?
    if record.class != Symbol
      return true if record.public && record.unassigned
    end

    return super
  end

  def assign_people?
    allowed?(action: :assign_people)
  end

  def unassign_people?
    allowed?(action: :unassign_people)
  end

  class Scope < PlannerPolicy::Scope
    def resolve
      if allowed?(action: :index)
        # Rails.logger.debug "**** ALL #{@person.id}"
        scope.all
      else
        scope.where(public: true)
      end
    end
  end
end
