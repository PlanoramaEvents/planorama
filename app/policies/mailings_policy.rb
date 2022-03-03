class MailingsPolicy < PlannerPolicy
  def assign_people?
    @person.person_groups.inject(false) { |res, grp| res || grp.admin? }
  end

  def unassign_people?
    @person.person_groups.inject(false) { |res, grp| res || grp.admin? }
  end

  def schedule?
    @person.person_groups.inject(false) { |res, grp| res || grp.admin? }
  end

  def preview?
    @person.person_groups.inject(false) { |res, grp| res || grp.admin? }
  end

  def clone?
    @person.person_groups.inject(false) { |res, grp| res || grp.admin? }
  end

  # class Scope < Scope
  #   def resolve
  #     if @person.person_groups.inject(false) { |res, grp| res || grp.admin? }
  #       Rails.logger.debug "**** ALL #{@person.id}"
  #       scope.all
  #     else
  #       scope.where(id: @person.id)
  #     end
  #   end
  # end
end
