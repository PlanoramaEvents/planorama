class ApplicationRolePolicy < PlannerPolicy
  def update?
    is_admin
  end

  def create?
    is_admin
  end

  def index?
    is_admin
  end

  def show?
    is_admin
  end

  def destroy?
    is_admin
  end

  def assign_people?
    is_admin
  end

  def unassign_people?
    is_admin
  end

  def assign_convention_role?
    is_admin
  end

  def unassign_convention_role?
    is_admin
  end

  class Scope < PlannerPolicy::Scope
    def resolve
      if @person.convention_roles.inject(false) { |res, grp| res || grp.admin?}
        scope.all
      else
        # return no records
        scope.where(id: nil)
      end
    end
  end
end
