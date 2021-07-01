class SurveysPolicy < PlannerPolicy
  # Anyone can see a survey ...
  def show?
    return true
  end

  # class Scope < Scope
  #   def resolve
  #     if @person.person_roles.inject(false) { |res, role| res || role.admin_role? }
  #       Rails.logger.debug "**** ALL #{@person.id}"
  #       scope.all
  #     else
  #       scope.where(id: @person.id)
  #     end
  #   end
  # end
end
