class ApplicationRolePolicy < PlannerPolicy
  def bletch?
    allowed?(action: :assign_people)
  end

  def assign_people?
    allowed?(action: :assign_people)
  end

  def unassign_people?
    allowed?(action: :unassign_people)
  end

  def assign_convention_role?
    allowed?(action: :assign_convention_role)
  end

  def unassign_convention_role?
    allowed?(action: :unassign_convention_role)
  end

  class Scope < PlannerPolicy::Scope
    def resolve
      if allowed?(action: :index)
        scope.all
      else # return no records
        scope.where(id: nil)
      end
    end
  end
end
