class PlannerPolicy < ApplicationPolicy
  def update?
    @person.person_roles.inject(false) { |res, role| res || role.admin_role? }
  end

  def create?
    @person.person_roles.inject(false) { |res, role| res || role.admin_role? }
  end

  def index?
    @person.person_roles.inject(false) { |res, role| res || role.admin_role? }
  end

  def show?
    @person.person_roles.inject(false) { |res, role| res || role.admin_role? }
  end

  def destroy?
    @person.person_roles.inject(false) { |res, role| res || role.admin_role? }
  end

  class Scope < Scope
    def resolve
      if @person.person_roles.inject(false) { |res, role| res || role.admin_role? }
        scope.all
      else
        if scope == Person
          scope.where(id: @person.id)
        elsif scope.attribute_method? :peron_id
          scope.where(person_id: @person.id)
        else
          # return no records
          scope.where(id: nil)
        end
      end
    end
  end
end
