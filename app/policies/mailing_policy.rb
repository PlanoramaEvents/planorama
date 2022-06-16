class MailingPolicy < PlannerPolicy
  def assign_people?
    allowed?(action: :assign_people)
  end

  def unassign_people?
    allowed?(action: :unassign_people)
  end

  def schedule?
    allowed?(action: :schedule)
  end

  def preview?
    allowed?(action: :preview)
  end

  def clone?
    allowed?(action: :clone)
  end

  class Scope < PlannerPolicy::Scope
    def resolve
      if allowed?(action: :index)
        scope.all
      else
        scope.where(id: @person.id)
      end
    end
  end
end
