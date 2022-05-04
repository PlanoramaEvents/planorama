class ApplicationPolicy
  attr_reader :person, :record

  # Helper method to call Access Control to see if requested action is allowed
  def allowed?(action:)
    return true if (@record.class != Symbol) && (@record.class == ::Person) && (@record.id == @person.id)

    if (@record.class != Symbol) && (!@record.is_a?(Class)) && (@record.has_attribute?(:person_id))
      return true if @record.person_id == @person.id
    end

    cname = self.class.name.split("::").first
    cname.slice! "Policy"
    cname = cname.singularize.snakecase.downcase

    AccessControlService.can_execute?(model: cname, action: action, person: @person)
  end

  def initialize(person, record)
    # check
    @person = person
    @record = record
  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  class Scope
    attr_reader :person, :scope

    def initialize(person, scope)
      @person = person
      @scope = scope
    end

    def resolve
      scope.all
    end
  end
end
