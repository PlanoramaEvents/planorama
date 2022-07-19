class PersonScheduleApprovalPolicy < PlannerPolicy
  # def index?
  #   true
  # end
  #
  def fetch?
    # return true if @record.class != Symbol && @record.person_id == @person.id

    allowed?(action: :fetch)
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
