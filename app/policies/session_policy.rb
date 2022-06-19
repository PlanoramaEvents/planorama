class SessionPolicy < PlannerPolicy
  def import?
    # @person.convention_roles.inject(false) { |res, grp| res || grp.admin? }
    allowed?(action: :import)
  end

  def express_interest?
    # @person.convention_roles.inject(false) { |res, grp| res || (grp.admin? || grp.staff? || grp.participant?) }
    allowed?(action: :express_interest)
  end

  # def index?
  #   # @person.convention_roles.inject(false) { |res, grp| res || (grp.admin? || grp.staff? || grp.participant?) }
  #   allowed?(action: :index)
  # end

  class Scope < PlannerPolicy::Scope
    def resolve
      scope.all
    end
  end
end
