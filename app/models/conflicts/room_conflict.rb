# == Schema Information
#
# Table name: room_conflicts
#
#  id                             :text             primary key
#  back_to_back                   :boolean
#  conflicting_session_duration   :integer
#  conflicting_session_end_time   :datetime
#  conflicting_session_start_time :datetime
#  conflicting_session_title      :string(256)
#  duration                       :integer
#  end_time                       :datetime
#  session_title                  :string(256)
#  start_time                     :datetime
#  conflicting_session_id         :uuid
#  room_id                        :uuid
#  session_id                     :uuid
#
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
