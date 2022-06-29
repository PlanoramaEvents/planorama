class Conflicts::SessionConflict < ApplicationRecord
  self.table_name = :session_conflicts
  self.primary_key = :conflict_id

  belongs_to :session
  belongs_to :person
  belongs_to :room
  belongs_to :session_assignment
  belongs_to :conflict_session, class_name: 'Session', inverse_of: :conflict_sessions

  def readonly?
    true
  end
end
