class PlannerPolicy < ApplicationPolicy
  def update?
    allowed?(action: :update)
  end

  def create?
    allowed?(action: :create)
  end

  def index?
    allowed?(action: :index)
  end

  def show?
    allowed?(action: :show)
  end

  def destroy?
    allowed?(action: :destroy)
  end

  class Scope < ApplicationPolicy::Scope
    def allowed?(action:)
      cname = self.class.name.split("::").first
      cname.slice! "Policy"
      cname = cname.singularize.snakecase

      AccessControlService.can_execute?(model: cname, action: action, person: @person)
    end

    def resolve
      if allowed?(action: :index)
        scope.all
      else
        if scope == Person
          scope.where(id: @person.id)
        elsif scope.attribute_method? :peron_id
          scope.where(person_id: @person.id)
        else # return no records
          scope.where(id: nil)
        end
      end
    end
  end
end
