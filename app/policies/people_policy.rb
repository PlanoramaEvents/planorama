class PeoplePolicy < PlannerPolicy
  def me?
    true
  end

  def import?
    @person.convention_roles.inject(false) { |res, grp| res || grp.admin? }
  end

  def assigned_surveys?
    return true if @record.class != Symbol && @record.id == @person.id

    @person.convention_roles.inject(false) { |res, grp| res || grp.admin? }
  end

  def submissions?
    return true if @record.class != Symbol && @record.id == @person.id

    @person.convention_roles.inject(false) { |res, grp| res || grp.admin? }
  end

  def update?
    return true if @record.class != Symbol && @record.id == @person.id

    @person.convention_roles.inject(false) { |res, grp| res || grp.admin? }
  end

  def show?
    return true if @record.class != Symbol && @record.id == @person.id

    @person.convention_roles.inject(false) { |res, grp| res || grp.admin? }
  end

  def mailed_surveys?
    return true if @record.class != Symbol && @record.id == @person.id

    @person.convention_roles.inject(false) { |res, grp| res || grp.admin? }
  end

  class Scope < Scope
    def resolve
      if @person.convention_roles.inject(false) { |res, grp| res || grp.admin? }
        scope.all
      else
        scope.where(id: @person.id)
      end
    end
  end
end
