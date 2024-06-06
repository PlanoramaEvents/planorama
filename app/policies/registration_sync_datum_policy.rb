class RegistrationSyncDatumPolicy < PlannerPolicy
  def people?
    allowed?(action: :people)
  end

  def sync_statistics?
    allowed?(action: :sync_statistics)
  end

  def synchronize?
    allowed?(action: :synchronize)
  end

  class Scope < PlannerPolicy::Scope
    def resolve
      scope.all
    end
  end
end
