class AgreementsPolicy < PlannerPolicy
  # Anyone can see ...
  def index?
    return true
  end

  def show?
    return true
  end

  def signed?
    return true if @person
  end

  def unsigned?
    return true if @person
  end

  def sign?
    return true if @person
  end

  # class Scope < Scope
  #   def resolve
  #     if @person.person_roles.inject(false) { |res, role| res || role.admin_role? }
  #       Rails.logger.debug "**** ALL #{@person.id}"
  #       scope.all
  #     else
  #       scope.where(id: @person.id)
  #     end
  #   end
  # end
end
