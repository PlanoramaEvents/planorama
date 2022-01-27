class SessionAssignmentPolicy < PlannerPolicy
  # def import?
  #   @person.person_roles.inject(false) { |res, role| res || role.admin_role? }
  # end

  # create/update should be limited to admin or the person that the assignment is for
  def create?
    return true if @record.person_id == @person.id

    @person.person_roles.inject(false) { |res, role| res || role.admin_role? }
  end

  def update?
    # @person.person_roles.inject(false) { |res, role| res || role.admin_role? }
    false
  end

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
