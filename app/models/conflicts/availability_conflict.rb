class Conflicts::AvailabilityConflict < ApplicationRecord
  self.table_name = :availability_conflicts
  self.primary_key = :session_assignment_id, :person_id, :session_id

  belongs_to :session_assignment
  belongs_to :person
  belongs_to :session
end

# TODO: add conflict check to assignment role type - i.e. leave out reserve
