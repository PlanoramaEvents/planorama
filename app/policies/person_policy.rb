class PersonPolicy < PlannerPolicy
  def me?
    true
  end

  # def index?
  #   allowed?(action: :me)
  #   # @person.convention_roles.inject(false) { |res, grp| res || grp.admin? }
  #   true
  # end

  def update_all?
    allowed?(action: :update_all)
  end

  def import?
    allowed?(action: :import)
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

    allowed?(action: :submissions)
  end

  def show?
    return true if @record.class != Symbol && @record.id == @person.id

    allowed?(action: :show)
  end

  def mailed_surveys?
    return true if @record.class != Symbol && @record.id == @person.id

    allowed?(action: :mailed_surveys)
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
