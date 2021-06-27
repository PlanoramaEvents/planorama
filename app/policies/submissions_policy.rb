class SubmissionsPolicy < PlannerPolicy
  def create?
    return true if @person
  end

  def update?
    return true if @record.person_id == @person.id

    @person.person_roles.inject(true) { |res, role| res && role.admin_role? }
  end

  def show?
    return true if @record.person_id == @person.id

    @person.person_roles.inject(true) { |res, role| res && role.admin_role? }
  end
end
