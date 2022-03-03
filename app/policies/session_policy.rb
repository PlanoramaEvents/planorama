class SessionPolicy < PlannerPolicy
  def import?
    @person.person_groups.inject(false) { |res, grp| res || grp.admin? }
  end

  # class Scope < Scope
  #   def resolve
  #     if @person.person_groups.inject(false) { |res, grp| res || grp.admin? }
  #       scope.all
  #     else
  #       scope.where(id: @person.id)
  #     end
  #   end
  # end
end
