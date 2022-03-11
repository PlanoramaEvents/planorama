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

    @person.convention_roles.inject(false) { |res, grp| res || grp.admin? }
  end

  def delete_all?
    @person.convention_roles.inject(false) { |res, grp| res || grp.admin? }
  end

  def update?
    # Only makes sense for updates to happen by planners or submitters
    # so anon surveys are excluded
    # record could be a symbol
    return true if @record.class != Symbol && @record.person_id == @person.id

    @person.convention_roles.inject(false) { |res, grp| res || grp.admin? }
  end

  def show?
    return true if @record.class != Symbol && @record && @record.person_id == @person.id
    # Anonymoous submission can be seen by anonymous perspn
    # TODO: this could be an issue
    # return true if @record.person_id == nil

    @person.convention_roles.inject(false) { |res, grp| res || grp.admin? }
  end
end
