class PersonSyncDatumPolicy < PlannerPolicy

  def possible_match_count?
    allowed?(action: :dismiss_match)
  end

  def dismiss_match?
    allowed?(action: :dismiss_match)
  end

  def match?
    allowed?(action: :match)
  end

  class Scope < PlannerPolicy::Scope
    def resolve
      scope.all
    end
  end
end
