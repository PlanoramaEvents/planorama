class PersonScheduleApprovalPolicy < PlannerPolicy
  def fetch?
    return true if @record.class != Symbol && @record.person_id == @person.id

    allowed?(action: :fetch)
  end

  def update?
    return true if @record.class != Symbol && @record.id == @person.id

    allowed?(action: :update)
  end

  def show?
    return true if @record.class != Symbol && @record.id == @person.id

    allowed?(action: :show)
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
