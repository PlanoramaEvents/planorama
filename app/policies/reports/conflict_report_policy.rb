class Reports::ConflictReportPolicy < BasePolicy
  def people_outside_availability?
    allowed?(action: :people_outside_availability)
  end

  def people_double_booked?
    allowed?(action: :people_double_booked)
  end

  def back_to_back?
    allowed?(action: :back_to_back)
  end

  def back_to_back_to_back?
    allowed?(action: :back_to_back_to_back)
  end

  def person_exclusion_conflicts?
    allowed?(action: :person_exclusion_conflicts)
  end

  def multiple_sessions_in_room?
    allowed?(action: :multiple_sessions_in_room)
  end

  def all_conflicts?
    allowed?(action: :all_conflicts)
  end

  def all_ignored_conflicts?
    allowed?(action: :all_ignored_conflicts)
  end
end
