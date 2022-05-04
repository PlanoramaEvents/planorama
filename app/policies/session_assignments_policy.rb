class SessionAssignmentsPolicy < PlannerPolicy
  def unexpress_interest?
    return true if @record.person_id == @person.id

    allowed?(action: :unexpress_interest)
  end

  # create/update should be limited to admin or the person that the assignment is for
  # def create?
  #   return true if @record.person_id == @person.id
  #
  #   is_admin_or_staff
  # end
  #
  # def update?
  #   return true if @record.person_id == @person.id
  #
  #   is_admin_or_staff
  # end
  #
  # def index?
  #   return true
  # end
  #
  # def show?
  #   return true if @record.person_id == @person.id
  #
  #   is_admin_or_staff
  # end

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
