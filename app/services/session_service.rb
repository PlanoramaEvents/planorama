module SessionService
  def self.participant_schedule_url
    workflow = ScheduleWorkflow.order("updated_at desc").first

    return UrlService.url_for(path: "/#/profile/draft-schedule") if workflow && workflow.state == ScheduleWorkflow.states[:draft]
    return UrlService.url_for(path: "/#/profile/schedule") if workflow && workflow.state == ScheduleWorkflow.states[:firm]

    return UrlService.url_for(path: '/')
  end

  # SessionService.draft_schedule_for(person: p)
  def self.draft_schedule_for(person:, current_person: nil)
    sched_table = ::PersonSchedule.arel_table
    subquery = Session.area_list.as('areas_list')

    joins = [
      sched_table.create_join(
        subquery,
        sched_table.create_on(
          subquery[:session_id].eq(sched_table[:session_id])
        ),
        Arel::Nodes::OuterJoin
      )
    ]

    schedule = PersonSchedule.select(
        PersonSchedule.arel_table[Arel.star],
        'areas_list.area_list'
      )
      .joins(joins)
      .eager_load(:room, :format, :primary_email)
      .where(person_id: person.id)
      .where("start_time is not null and room_id is not null")
      .where("con_state != 'declined' AND con_state != 'rejected'")
      .where("session_assignment_name in (?)",['Moderator', 'Participant', 'Invisible'])


    PersonScheduleSerializer.new(schedule).serializable_hash
  end

  # Get all the schedule sessions
  # ActiveModel::Serializer::CollectionSerializer.new(
  #           sessions,
  #           serializer: Conclar::SessionSerializer
  #         )
  def self.scheduled_sessions
    if PublishedSession.count > 0 || Rails.env.production?
      self.published_sessions
    else
      self.live_sessions
    end
  end

  def self.cache_published_sessions(publication_date:)
    sessions = self.published_sessions

    snapshot = ActiveModel::Serializer::CollectionSerializer.new(
                  sessions,
                  serializer: Conclar::SessionSerializer
                ) #.serializable_hash

    PublishSnapshot.create!(
      snapshot: snapshot,
      label: 'schedule',
      publication_date: publication_date
    )
  end

  def self.cache_published_participants(publication_date:)
    participants = self.scheduled_people

    snapshot = ActiveModel::Serializer::CollectionSerializer.new(
              participants,
              serializer: Conclar::ParticipantSerializer
            ) #.serializable_hash

    PublishSnapshot.create!(
      snapshot: snapshot,
      label: 'participants',
      publication_date: publication_date
    )
  end

  # ActiveModel::Serializer::CollectionSerializer.new(
  #           participants,
  #           serializer: Conclar::ParticipantSerializer
  #         ),
  def self.scheduled_people
    # TODO: when publish process done change condition
    if PublishedSession.count > 0 || Rails.env.production?
      self.published_people
    else
      self.live_people
    end
  end

  def self.published_sessions_unordered
    PublishedSession.select(
      ::PublishedSession.arel_table[Arel.star],
      'areas_list.area_list'
    )
      .includes(:format, :room, {participant_assignments: :person})
      .joins(self.area_subquery(clazz: PublishedSession))
  end

  def self.published_sessions
    self.published_sessions_unordered.order(:start_time)
  end

  def self.live_sessions
    Session.select(
      ::Session.arel_table[Arel.star],
      'areas_list.area_list'
    )
      .includes(:format, :room, {participant_assignments: :person})
      .joins(self.area_subquery)
      .where("start_time is not null and room_id is not null")
      .where("status != 'dropped' and status != 'draft'")
      .order(:start_time)
  end

  def self.published_people
    moderator = SessionAssignmentRoleType.find_by(name: 'Moderator')
    participant = SessionAssignmentRoleType.find_by(name: 'Participant')

    people = Person.includes(
      {published_session_assignments: [:published_session, :session_assignment_role_type]}
    ).references(
      {published_session_assignments: :published_session}
    )
    .where("published_session_assignments.session_assignment_role_type_id in (?)", [moderator.id, participant.id])
    .where("published_sessions.start_time is not null and published_sessions.room_id is not null")
    .where("people.con_state not in (?)", ['declined', 'rejected']) #.distinct
    .order("people.published_name")
  end

  def self.live_people
    moderator = SessionAssignmentRoleType.find_by(name: 'Moderator')
    participant = SessionAssignmentRoleType.find_by(name: 'Participant')

    people = Person.includes(
      {session_assignments: [:session, :session_assignment_role_type]}
    ).references(
      {session_assignments: :session}
    )
    .where("session_assignments.session_assignment_role_type_id in (?)", [moderator.id, participant.id])
    .where("sessions.start_time is not null and sessions.room_id is not null")
    .where("sessions.status != 'dropped' and sessions.status != 'draft'")
    .where("people.con_state not in (?)", ['declined', 'rejected']) #.distinct
    .order("people.published_name")
  end

  def self.live_moderators
    moderator = SessionAssignmentRoleType.find_by(name: 'Moderator')

    people = Person.includes(
      {session_assignments: [:session, :session_assignment_role_type]}
    ).references(
      {session_assignments: :session}
    )
    .where("session_assignments.session_assignment_role_type_id in (?)", [moderator.id])
    .where("sessions.start_time is not null and sessions.room_id is not null")
    .where("sessions.status != 'dropped' and sessions.status != 'draft'")
    .where("people.con_state not in (?)", ['declined', 'rejected']) #.distinct
    .order("people.published_name")
  end

  def self.area_subquery(clazz: Session)
    session_table = clazz.arel_table
    areas_list = clazz.area_list.as('areas_list')
    id = (clazz == Session) ? :id : :session_id
    [
      session_table.create_join(
        areas_list,
        session_table.create_on(
          areas_list[:session_id].eq(session_table[id])
        ),
        Arel::Nodes::OuterJoin
      )
    ]
  end
end
