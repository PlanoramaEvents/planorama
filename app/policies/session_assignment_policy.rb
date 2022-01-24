class SessionAssignmentPolicy < PlannerPolicy
  # def import?
  #   @person.person_roles.inject(false) { |res, role| res || role.admin_role? }
  # end

  class Scope < Scope
    def resolve
      # Rails.logger.debug "**** ALL #{@person.name}"
      if @person.person_roles.inject(false) { |res, role| res || role.admin_role? }
        scope.all
      else
        scope.where(person_id: @person.id)
      end
    end
  end
end
