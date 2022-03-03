class SurveysPolicy < PlannerPolicy
  # Anyone can see a survey ...
  def show?
    return true
  end

  def assign_people?
    @person.person_groups.inject(false) { |res, grp| res || grp.admin? }
  end

  def unassign_people?
    @person.person_groups.inject(false) { |res, grp| res || grp.admin? }
  end

  class Scope < Scope
    def resolve
      if @person.person_groups.inject(false) { |res, grp| res || grp.admin? }
        # Rails.logger.debug "**** ALL #{@person.id}"
        scope.all
      else
        scope.where(public: true)
      end
    end
  end
end
