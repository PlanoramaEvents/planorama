class MailingsPolicy < PlannerPolicy
  def assign_people?
    @person.convention_roles.inject(false) { |res, grp| res || grp.admin? }
  end

  def unassign_people?
    @person.convention_roles.inject(false) { |res, grp| res || grp.admin? }
  end

  def schedule?
    @person.convention_roles.inject(false) { |res, grp| res || grp.admin? }
  end

  def preview?
    @person.convention_roles.inject(false) { |res, grp| res || grp.admin? }
  end

  def clone?
    @person.convention_roles.inject(false) { |res, grp| res || grp.admin? }
  end

  # class Scope < Scope
  #   def resolve
  #     if @person.convention_roles.inject(false) { |res, grp| res || grp.admin? }
  #       Rails.logger.debug "**** ALL #{@person.id}"
  #       scope.all
  #     else
  #       scope.where(id: @person.id)
  #     end
  #   end
  # end
end
