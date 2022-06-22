class Conflicts::SessionConflict < ApplicationRecord
  self.table_name = :session_conflicts
  self.primary_key = :conflict_id

  belongs_to :session
  belongs_to :person
  belongs_to :room
  belongs_to :session_assignment
  belongs_to :conflict_session, class_name: 'Session'

  def readonly?
    true
  end
end

# Availabuility
# person, session_assignment
# session, person not available
# (session, person)
#
# BackToBack
# person, session_assignment1, session_assignment2
# session, person scheduled right before/after
# (session, person, session)
#
# Double Booked
# person, session_assignment1, session_assignment2
# session, person scheduled in at same time
# (session, person, session)
#
# Room Conflict
# room, session1, session2
# session in same room as session 2
# (session, room, session)
#
