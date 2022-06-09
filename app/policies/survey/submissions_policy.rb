class Survey::SubmissionsPolicy < PlannerPolicy
  def create?
    # Anyone can create a submission
    return true #if @person
  end

  def flat?
    # Rails.logger.debug "********* #{@record} #{@person}"
    # return true if @record.class != Symbol && @record && @record.person_id == @person.id
    # Anonymoous submission can be seen by anonymous perspn
    # TODO: this could be an issue
    # return true if @record.person_id == nil
    allowed?(action: :flat)
  end

  def delete_all?
    allowed?(action: :delete_all)
  end

  def update?
    # return true
    # Only makes sense for updates to happen by planners or submitters
    # so anon surveys are excluded
    # record could be a symbol
    return true if @record.class != Symbol && @record.person_id == @person.id
    #
    allowed?(action: :update)
  end

  def show?
    return true if @record.class != Symbol && @record && @record.person_id == @person.id
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
