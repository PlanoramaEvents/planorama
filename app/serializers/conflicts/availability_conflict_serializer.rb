# == Schema Information
#
# Table name: availability_conflicts
#
#  id                              :text             primary key
#  person_name                     :string
#  person_published_name           :string
#  session_assignment_name         :string(100)
#  session_assignment_role_type    :enum
#  session_duration                :integer
#  session_start_time              :datetime
#  session_title                   :string(256)
#  person_id                       :uuid
#  session_assignment_id           :uuid
#  session_assignment_role_type_id :uuid
#  session_id                      :uuid
#  session_room_id                 :uuid
#
class Conflicts::AvailabilityConflictSerializer
  include JSONAPI::Serializer

  # attribute :id do |obj|
  #   obj.id.join(',')
  # end

  belongs_to :session_assignment, serializer: SessionAssignmentSerializer
  belongs_to :person, serializer: PersonSerializer
  belongs_to :session,  serializer: SessionSerializer
end
