class SessionAssignmentPolicy < PlannerPolicy
  # def import?
  #   @person.person_groups.inject(false) { |res, grp| res || grp.admin? }
  # end

  # create/update should be limited to admin or the person that the assignment is for
  def create?
    return true if @record.person_id == @person.id

    @person.person_groups.inject(false) { |res, grp| res || grp.admin? }
  end

  def update?
    return true if @record.person_id == @person.id

    @person.person_groups.inject(false) { |res, grp| res || grp.admin? }
  end

  class Scope < Scope
    def resolve
      # Rails.logger.debug "**** ALL #{@person.name}"
      if @person.person_groups.inject(false) { |res, grp| res || grp.admin? }
        scope.all
      else
        scope.where(person_id: @person.id)
      end
    end
  end
end
