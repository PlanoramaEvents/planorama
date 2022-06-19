class PersonExclusionPolicy < PlannerPolicy
  def index?
    # return true if @record.class != Symbol && @record.id == @person.id
    # TODO???
    # @person.convention_roles.inject(false) { |res, grp| res || grp.admin? }
    true
  end

  # def create?
  #   return true if @record.class != Symbol && @record.id == @person.id
  #
  #   is_admin_or_staff
  # end
  #
  # def update?
  #   return true if @record.class != Symbol && @record.id == @person.id
  #
  #   is_admin_or_staff
  # end
  #
  # def show?
  #   return true if @record.class != Symbol && @record.id == @person.id
  #
  #   is_admin_or_staff
  # end
  #
  # def destroy?
  #   return true if @record.class != Symbol && @record.id == @person.id
  #
  #   is_admin_or_staff
  # end

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
