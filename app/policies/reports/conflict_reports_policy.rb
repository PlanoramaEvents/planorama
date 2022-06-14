class Reports::ConflictReportsPolicy < BasePolicy
  def people_outside_availability?
    allowed?(action: :people_outside_availability)
  end
end
