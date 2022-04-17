class EmailAddressesPolicy < PlannerPolicy
  def index?
    # @person.convention_roles.inject(false) { |res, grp| res || grp.admin? }
    true
  end

  def create?
    # @person.convention_roles.inject(false) { |res, grp| res || grp.admin? }
    true
  end

  def update?
    return true if @record.class != Symbol && @record.person_id == @person.id

    is_admin_or_staff
  end

  def destroy?
    return true if @record.class != Symbol && @record.person_id == @person.id

    is_admin_or_staff
  end

  def show?
    return true if @record.class != Symbol && @record.person_id == @person.id

    is_admin_or_staff
  end

  def mailed_surveys?
    return true if @record.class != Symbol && @record.person_id == @person.id

    is_admin_or_staff
  end

  class Scope < PlannerPolicy::Scope
    def resolve
      if is_admin_or_staff
        scope.all
      else
        scope.where(person_id: @person.id)
      end
    end
  end
end
