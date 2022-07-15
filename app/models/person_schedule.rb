class PersonSchedule < ApplicationRecord
  self.table_name = :person_schedules
  self.primary_key = :id

  belongs_to :session_assignment
  belongs_to :person
  belongs_to :session
  belongs_to :session_assignment_role_type
  belongs_to :room
  belongs_to :format

  # has_many  :email_addresses, dependent: :destroy, foreign_key: :conflict_session_id
  has_one :primary_email,
          -> { where(['email_addresses.isdefault = true']) },
          class_name: 'EmailAddress',
          primary_key: 'person_id',
          foreign_key: 'person_id'


  # has_many :participant_assignments, class_name: 'SessionAssignment', primary_key: 'session_id', foreign_key: 'session_id'
  has_many :moderators, -> (object) {
             where("session_assignment_name in (?)",['Moderator'])
             .order('published_name')
           },
           class_name: 'PersonSchedule',
           primary_key: 'session_id',
           foreign_key: 'session_id'

  has_many :participants, -> (object) {
            where("session_assignment_name in (?)",['Participant'])
            .order('published_name')
          },
          class_name: 'PersonSchedule',
          primary_key: 'session_id',
          foreign_key: 'session_id'

  has_many :invisibles, -> (object) {
            where("session_assignment_name in (?)",['Invisible'])
            .order('published_name')
          },
          class_name: 'PersonSchedule',
          primary_key: 'session_id',
          foreign_key: 'session_id'

  def readonly?
    true
  end
end

# CONCAT(p.id, ':', sa.id) as id,
# p.id as person_id ,
# p.name,
# p.published_name,
# p.con_state,
# p.pronouns
# sa.id as session_assignment_id,
# sart.id as session_assignment_role_type_id,
# sart.name as session_assignment_name,
# sart.role_type as session_assignment_role_type,
# sa.sort_order,
# sessions.id as session_id,
# sessions.title,
# sessions.start_time,
# (sessions.start_time + (sessions.duration || ' minute')::interval) as end_time,
# sessions.duration,
# sessions.room_id,
# sessions.format_id
