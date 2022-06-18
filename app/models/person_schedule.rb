class PersonSchedule < ApplicationRecord
  self.table_name = :person_schedules
  self.primary_key = :id

  belongs_to :session_assignment
  belongs_to :person
  belongs_to :session
  belongs_to :session_assignment_role_type
  belongs_to :room

  def readonly?
    true
  end
end
