class SurveysPolicy < PlannerPolicy
  # Anyone can see a survey ...
  def show?
    return true
  end

  def assign_people?
    @person.person_roles.inject(false) { |res, role| res || role.admin_role? }
  end

  def unassign_people?
    @person.person_roles.inject(false) { |res, role| res || role.admin_role? }
  end

  class Scope < Scope
    def resolve
      if @person.person_roles.inject(false) { |res, role| res || role.admin_role? }
        # Rails.logger.debug "**** ALL #{@person.id}"
        scope.all
      else
        scope.where(public: true)
      end
    end
  end
end
