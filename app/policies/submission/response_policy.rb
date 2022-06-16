class Submission::ResponsePolicy < PlannerPolicy
  def create?
    # Anyone can create a submission response ....
    return true #if @person
  end

  def update?
    # return true if @record.class != Symbol && @record.person_id == @person.id
    allowed?(action: :update)
  end

  def show?
    # return true if @record.class != Symbol && @record && @record.person_id == @person.id
    # Anonymoous submission can be seen by anonymous perspn
    # TODO: this could be an issue

    allowed?(action: :show)
  end

  class Scope < PlannerPolicy::Scope
    def resolve
      if allowed?(action: :index)
        scope.all
        # scope.where(person_id: @person.id)
      end
    end
  end
end
