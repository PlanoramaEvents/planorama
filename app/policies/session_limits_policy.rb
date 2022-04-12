class SessionLimitsPolicy < PlannerPolicy
  def index?
    # return true if @record.class != Symbol && @record.id == @person.id
    # TODO???
    # @person.convention_roles.inject(false) { |res, grp| res || grp.admin? }
    true
  end

  def create?
    return true if @record.class != Symbol && @record.person_id == @person.id

    @person.convention_roles.inject(false) { |res, grp| res || grp.admin? }
  end

  def update?
    return true if @record.class != Symbol && @record.person_id == @person.id

    @person.convention_roles.inject(false) { |res, grp| res || grp.admin? }
  end

  def show?
    return true if @record.class != Symbol && @record.person_id == @person.id

    @person.convention_roles.inject(false) { |res, grp| res || grp.admin? }
  end

  def destroy?
    return true if @record.class != Symbol && @record.person_id == @person.id

    @person.convention_roles.inject(false) { |res, grp| res || grp.admin? }
  end

  class Scope < Scope
    def resolve
      if @person.convention_roles.inject(false) { |res, grp| res || grp.admin? }
        scope.all
      else
        scope.where(person_id: @person.id)
      end
    end
  end

end
