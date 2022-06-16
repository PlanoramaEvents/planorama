class SessionAssignmentPolicy < PlannerPolicy
  def unexpress_interest?
    return true if @record.person_id == @person.id

    allowed?(action: :unexpress_interest)
  end

  class Scope < PlannerPolicy::Scope
    def resolve
      # Rails.logger.debug "**** ALL #{@person.name}"
      if allowed?(action: :index)
        scope.all
      else
        scope.where(person_id: @person.id)
      end
    end
  end
end
