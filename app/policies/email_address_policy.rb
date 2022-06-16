class EmailAddressPolicy < PlannerPolicy
  # def index?
  #   # @person.convention_roles.inject(false) { |res, grp| res || grp.admin? }
  #   true
  # end
  #
  # def create?
  #   # @person.convention_roles.inject(false) { |res, grp| res || grp.admin? }
  #   true
  # end
  #
  # def update?
  #   return true if @record.class != Symbol && @record.person_id == @person.id
  #
  #   is_admin_or_staff
  # end
  #
  # def destroy?
  #   return true if @record.class != Symbol && @record.person_id == @person.id
  #
  #   is_admin_or_staff
  # end
  #
  # def show?
  #   return true if @record.class != Symbol && @record.person_id == @person.id
  #
  #   is_admin_or_staff
  # end

  def mailed_surveys?
    allowed?(action: :mailed_surveys)
  end

  class Scope < PlannerPolicy::Scope
    def resolve
      if allowed?(action: :index)
        scope.all
      else
        scope.where(person_id: @person.id)
      end
    end
  end
end
