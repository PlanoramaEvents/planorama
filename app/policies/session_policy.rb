class SessionPolicy < PlannerPolicy
  def import?
    @person.person_roles.inject(false) { |res, role| res || role.admin_role? }
  end

  # class Scope < Scope
  #   def resolve
  #     if @person.person_roles.inject(false) { |res, role| res || role.admin_role? }
  #       scope.all
  #     else
  #       scope.where(id: @person.id)
  #     end
  #   end
  # end
end
