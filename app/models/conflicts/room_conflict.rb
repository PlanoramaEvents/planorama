class Conflicts::RoomConflict < ApplicationRecord
  self.table_name = :room_conflicts
  self.primary_key = :id

  belongs_to :session
  belongs_to :room
  belongs_to :conflicting_session, class_name: 'Session'

  def readonly?
    true
  end
end
