class PublishedSessionPolicy < PlannerPolicy
  def resync_airmeet?
    allowed?(action: :resync_airmeet)
  end

  class Scope < PlannerPolicy::Scope
    def resolve
      scope.all
    end
  end
end
