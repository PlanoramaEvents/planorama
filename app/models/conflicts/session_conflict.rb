# == Schema Information
#
# Table name: session_conflicts
#
#  conflict_session_assignment_name         :text
#  conflict_session_duration                :integer
#  conflict_session_start_time              :datetime
#  conflict_session_title                   :string
#  conflict_type                            :text
#  person_name                              :string
#  person_published_name                    :string
#  session_assignment_name                  :string
#  session_duration                         :integer
#  session_start_time                       :datetime
#  session_title                            :string(256)
#  conflict_id                              :text             primary key
#  conflict_session_assignment_role_type_id :uuid
#  conflict_session_id                      :uuid
#  person_id                                :uuid
#  room_id                                  :uuid
#  session_assignment_id                    :uuid
#  session_assignment_role_type_id          :uuid
#  session_id                               :uuid
#
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
