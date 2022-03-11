class SessionPolicy < PlannerPolicy
  def import?
    @person.convention_roles.inject(false) { |res, grp| res || grp.admin? }
  end

  # class Scope < Scope
  #   def resolve
  #     if @person.convention_roles.inject(false) { |res, grp| res || grp.admin? }
  #       scope.all
  #     else
  #       scope.where(id: @person.id)
  #     end
  #   end
  # end
end
