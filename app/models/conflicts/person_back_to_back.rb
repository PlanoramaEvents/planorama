class Conflicts::PersonBackToBack < ApplicationRecord
  self.table_name = :person_back_to_back
  self.primary_key = :id

  belongs_to :session_assignment
  belongs_to :person
  belongs_to :session
  belongs_to :session_assignment_role_type
  belongs_to :room

  belongs_to :conflict_session_assignment, class_name: 'SessionAssignment'
  belongs_to :conflict_session, class_name: 'Session'
  belongs_to :conflict_session_assignment_role_type, class_name: 'SessionAssignmentRoleType'
  belongs_to :conflict_room, class_name: 'Room'

  def readonly?
    true
  end
end
