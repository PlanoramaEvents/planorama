# == Schema Information
#
# Table name: person_schedule_conflicts
#
#  id                                       :text             primary key
#  con_state                                :enum
#  conflict_duration                        :integer
#  conflict_end_time                        :datetime
#  conflict_session_assignment_name         :string(100)
#  conflict_session_assignment_role_type    :enum
#  conflict_session_title                   :string(256)
#  conflict_start_time                      :datetime
#  duration                                 :integer
#  end_time                                 :datetime
#  name                                     :string
#  published_name                           :string
#  session_assignment_name                  :string(100)
#  session_assignment_role_type             :enum
#  start_time                               :datetime
#  title                                    :string(256)
#  conflict_room_id                         :uuid
#  conflict_session_assignment_role_type_id :uuid
#  conflict_session_id                      :uuid
#  person_id                                :uuid
#  room_id                                  :uuid
#  session_assignment_id                    :uuid
#  session_assignment_role_type_id          :uuid
#  session_id                               :uuid
#
class Conflicts::PersonScheduleConflict < ApplicationRecord
  self.table_name = :person_schedule_conflicts
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
