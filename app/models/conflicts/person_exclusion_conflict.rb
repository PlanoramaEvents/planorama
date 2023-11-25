# == Schema Information
#
# Table name: person_exclusion_conflicts
#
#  id                              :text             primary key
#  con_state                       :enum
#  duration                        :integer
#  end_time                        :datetime
#  excluded_session_title          :string(256)
#  name                            :string
#  published_name                  :string
#  session_assignment_name         :string(100)
#  session_assignment_role_type    :enum
#  start_time                      :datetime
#  title                           :string(256)
#  excluded_session_id             :uuid
#  exclusion_id                    :uuid
#  person_id                       :uuid
#  room_id                         :uuid
#  session_assignment_id           :uuid
#  session_assignment_role_type_id :uuid
#  session_id                      :uuid
#
class Conflicts::PersonExclusionConflict < ApplicationRecord
  self.table_name = :person_exclusion_conflicts
  self.primary_key = :id

  belongs_to :person
  belongs_to :exclusion
  belongs_to :session
  belongs_to :excluded_session, class_name: 'Session'

  def readonly?
    true
  end
end
