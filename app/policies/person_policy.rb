class PersonPolicy < PlannerPolicy
  def me?
    true
  end

  # def index?
  #   allowed?(action: :me)
  #   # @person.convention_roles.inject(false) { |res, grp| res || grp.admin? }
  #   true
  # end

  def check_password?
    true
  end

  def update_all?
    allowed?(action: :update_all)
  end

  def session_names?
    allowed?(action: :session_names)
  end

  def import?
    allowed?(action: :import)
  end

  def unlink_registration?
    allowed?(action: :unlink_registration)
  end

  def live_sessions?
    return true if @record.class != Symbol && @record.id == @person.id

    allowed?(action: :live_sessions)
  end

  def snapshot_schedule?
    return true if @record.class != Symbol && @record.id == @person.id

    allowed?(action: :snapshot_schedule)
  end

  def assigned_surveys?
    return true if @record.class != Symbol && @record.id == @person.id

    allowed?(action: :assigned_surveys)
  end

  def submissions?
    return true if @record.class != Symbol && @record.id == @person.id

    allowed?(action: :submissions)
  end

  def update?
    return true if @record.class != Symbol && @record.id == @person.id

    allowed?(action: :update)
  end

  def show?
    return true if @record.class != Symbol && @record.id == @person.id

    allowed?(action: :show)
  end

  def mailed_surveys?
    return true if @record.class != Symbol && @record.id == @person.id

    allowed?(action: :mailed_surveys)
  end

  def resync_airmeet?
    allowed?(action: :resync_airmeet)
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
