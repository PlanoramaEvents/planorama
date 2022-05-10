class AvailabilitiesPolicy < PlannerPolicy
  # def index?
  #   # return true if @record.class != Symbol && @record.id == @person.id
  #   # TODO???
  #   # @person.convention_roles.inject(false) { |res, grp| res || grp.admin? }
  #   true
  # end

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
