class PeoplePolicy < PlannerPolicy
  def me?
    true
  end

  def index?
    # @person.convention_roles.inject(false) { |res, grp| res || grp.admin? }
    true
  end

  def update_all?
    is_admin_or_staff
  end

  def import?
    @person.convention_roles.inject(false) { |res, grp| res || grp.admin? }
  end

  def assigned_surveys?
    return true if @record.class != Symbol && @record.id == @person.id

    is_admin_or_staff
  end

  def submissions?
    return true if @record.class != Symbol && @record.id == @person.id

    is_admin_or_staff
  end

  def update?
    return true if @record.class != Symbol && @record.id == @person.id

    is_admin_or_staff
  end

  def show?
    return true if @record.class != Symbol && @record.id == @person.id

    is_admin_or_staff
  end

  def mailed_surveys?
    return true if @record.class != Symbol && @record.id == @person.id

    is_admin_or_staff
  end

  class Scope < PlannerPolicy::Scope
    def resolve
      if is_admin_or_staff
        scope.all
      else
        scope.where(id: @person.id)
      end
    end
  end
end
