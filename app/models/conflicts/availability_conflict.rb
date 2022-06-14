class Conflicts::AvailabilityConflict < ApplicationRecord
  self.table_name = :availability_conflicts
  self.primary_key = :id

  belongs_to :session_assignment
  belongs_to :person
  belongs_to :session
  belongs_to :session_assignment_role_type

  def readonly?
    true
  end
end
