class PlannerPolicy < ApplicationPolicy
  def update?
    @user.person_roles.inject(true) { |res, role| res && role.admin_role? }
  end

  def create?
    @user.person_roles.inject(true) { |res, role| res && role.admin_role? }
  end

  def index?
    @user.person_roles.inject(true) { |res, role| res && role.admin_role? }
  end

  def show?
    @user.person_roles.inject(true) { |res, role| res && role.admin_role? }
  end

  def destroy?
    @user.person_roles.inject(true) { |res, role| res && role.admin_role? }
  end

  class Scope < Scope
    def resolve
      if user.person_roles.inject(true) { |res, role| res && role.admin_role? }
        scope.all
      else
        if scope == Person
          scope.where(id: user.id)
        elsif scope.attribute_method? :peron_id
          scope.where(person_id: user.id)
        else
          # return no records
          scope.where(id: nil)
        end
      end
    end
  end
end
