class Reports::ConflictReportsPolicy < BasePolicy
  def people_outside_availability?
    allowed?(action: :people_outside_availability)
  end

  def people_double_booked?
    allowed?(action: :people_double_booked)
  end

  def back_to_back?
    allowed?(action: :back_to_back)
  end
end
