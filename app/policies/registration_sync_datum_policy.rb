class RegistrationSyncDatumPolicy < PlannerPolicy
  def people?
    allowed?(action: :people)
  end

  class Scope < PlannerPolicy::Scope
    def resolve
      scope.all
    end
  end
end
