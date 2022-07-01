module ReportsService

  def self.assigned_sessions_not_scheduled
    active_roles = SessionAssignmentRoleType.where("role_type = 'participant' and name != 'Reserve'")

    Session.select(
      ::Session.arel_table[Arel.star],
      'areas_list.area_list'
    )
      .joins(self.area_subquery)
      .joins(:session_assignments)
      .eager_load(:areas, {session_assignments: [:person]})
      .where("session_assignments.session_assignment_role_type_id in (?)", active_roles.collect{|a| a.id})
      .where("sessions.start_time is null or sessions.room_id is null")
      .order('sessions.title')
  end

  def self.scheduled_session_no_people
    active_roles = SessionAssignmentRoleType.where("role_type = 'participant' and (name != 'Invisible' and name != 'Reserve')")

    # Get all sessions that are scheduled with people in role
    session_with_people = PersonSchedule.where("session_assignment_role_type_id in (?)", active_roles.collect{|a| a.id})
    # Then get all scheduled sessions not in the above
    Session.select(
      ::Session.arel_table[Arel.star],
      'areas_list.area_list'
    )
      .joins(self.area_subquery)
      .where("start_time is not null and room_id is not null")
      .where("sessions.id not in (?)", session_with_people.collect{|a| a.session_id})
      .order(:start_time)


    # Session.select(
    #   ::Session.arel_table[Arel.star],
    #   'areas_list.area_list'
    # )
    #   .joins(:session_assignments)
    #   .eager_load(:areas, :room)
    #   .where("session_assignments.session_assignment_role_type_id not in (?)", active_roles.collect{|a| a.id})
    #   .where("start_time is not null and room_id is not null")
    #   .order(:start_time)
  end


  def self.sessions_with_no_moderator
    sched_table = PersonSchedule.arel_table
    session_and_roles = sched_table.project(
      :session_id,
      Arel::Nodes::NamedFunction.new('array_agg',[sched_table[:session_assignment_name]]).as('roles')
    ).group(:session_id).as('session_and_roles')

    sessions = Session.arel_table
    joins = [
      sessions.create_join(
        session_and_roles,
        sessions.create_on(
          session_and_roles[:session_id].eq(sessions[:id]).and(
            ::Arel.sql("'Moderator' != ALL(session_and_roles.roles)")
          )
        )
      )
    ]

    Session.select(
      ::Session.arel_table[Arel.star],
      'areas_list.area_list'
    )
      .joins(joins)
      .joins(self.area_subquery)
      .eager_load(:areas, :format, {session_assignments: [:person]})
      .order(:start_time)
  end

  # ReportsService.participant_and_con_session_limits
  def self.participant_and_con_session_limits(con_limit: 6)
    person_schedules = Arel::Table.new("person_schedules")
    active_roles = SessionAssignmentRoleType.where("role_type = 'participant' and (name != 'Invisible' and name != 'Reserve')")
    excluded_formats = Format.where("name in (?)",['Table Talk', 'Reading', 'Autographing'])

    Person
      .select(
        ::Person.arel_table[Arel.star],
        'count(people.id) as session_count'
      )
      .left_outer_joins(:person_schedules)
      .where("person_schedules.session_assignment_role_type_id in (?)", active_roles.collect{|a| a.id})
      .where("person_schedules.format_id not in (?)", excluded_formats.collect{|f| f.id})
      .group('people.id')
      .having("count(people.id) > ?", con_limit)
      .order('people.published_name')
  end

  # ReportsService.participant_and_session_limits
  def self.participant_and_session_limits
    timezone = ConfigService.value('convention_timezone')

    Time.use_zone(timezone) do
      people = ::Person.arel_table
      session_limits = SessionLimit.arel_table
      count_query = self.rollup_day_counts.as('count_query')
      Person
        .select(
          ::Person.arel_table[Arel.star],
          'count_query.day',
          'count_query.session_count',
          'session_limits.max_sessions'
        )
        .joins(
          [
            people.create_join(
              count_query,
              people.create_on(
                count_query[:id].eq(people[:id])
              )
            )
          ],
          [
            count_query.create_join(
              session_limits,
              count_query.create_on(
                session_limits[:person_id].eq(count_query[:id]).and(
                  session_limits[:day].eq(
                    Arel::Nodes::NamedFunction.new "cast", [count_query[:day].as('date')]
                  ).or(
                    session_limits[:day].eq(nil).and(
                      count_query[:day].eq(nil)
                    )
                  )
                )
              )
            )
          ]
        )
        .where(
          "count_query.session_count > session_limits.max_sessions"
        )
        .order('people.published_name, count_query.day asc')
    end
  end

  # ReportsService.rollup_day_counts
  def self.rollup_day_counts
    day_counts = people_day_counts.as('day_counts')
    people = ::Person.arel_table

    people.project(
      people[:id],
      day_counts[:day],
      day_counts[:session_count].sum.as('session_count')
    )
    .join(day_counts).on(day_counts[:person_id].eq(people[:id]))
    .group(
      people[:id], 'rollup(day_counts.day)'
    ).order(people[:id]) #'day_counts.person_id')
  end

  # ReportsService.people_day_counts
  def self.people_day_counts
    active_roles = SessionAssignmentRoleType.where("role_type = 'participant' and (name != 'Invisible' and name != 'Reserve')")
    people = ::Person.arel_table
    person_schedules = Arel::Table.new("person_schedules") # TODO - put in a view

    people.project(
      people[:id].as('person_id'),
      people[:id].count.as('session_count'),
      self.day_fn().as('day')
    )
    .join(person_schedules).on(person_schedules[:person_id].eq(people[:id]))
    .where(person_schedules[:session_assignment_role_type_id].in(active_roles.collect{|a| a.id}))
    .group(people[:id], self.day_fn())
    .order("people.id")
  end

  # ReportsService.day_fn
  def self.day_fn
    start_time = Time.parse(ConfigService.value('convention_start_time')).beginning_of_day
    end_time = Time.parse(ConfigService.value('convention_end_time')).end_of_day
    days = (end_time - start_time).round / (24 * 60 * 60)
    person_schedules = Arel::Table.new("person_schedules") #::Session.arel_table

    clause = Arel::Nodes::Case.new
    (0..(days-1)).each do |day|
      clause = clause.when(
        person_schedules[:start_time]
        .gteq(start_time + (day*24).hour)
        .and(
          person_schedules[:start_time].lteq(start_time + ((day+1)*24).hour)
        )
      ).then((start_time + (day*24).hour).to_date)
    end

    clause
  end

  def self.panels_with_too_few_people
    sub = self.sessions_and_participant_count.as("session_list")
    self.panels_with_counts(sub).where(sub[:nbr_assignments].lteq(3))
  end

  def self.panels_with_too_many_people
    sub = self.sessions_and_participant_count.as("session_list")
    self.panels_with_counts(sub).where(sub[:nbr_assignments].gteq(6))
  end

  def self.panels_with_counts(sub)
    session_table = Session.arel_table
    sessions = Session.select(
        ::Session.arel_table[Arel.star],
        sub[:nbr_assignments],
        'areas_list.area_list'
      )
      .joins(
        [
          session_table.create_join(
            sub,
            session_table.create_on(
              sub[:id].eq(session_table[:id])
            ),
            Arel::Nodes::OuterJoin
          )
        ]
      )
      .joins(area_subquery)
      .eager_load(:areas, {session_assignments: [:person]})
      .where("session_assignments.session_assignment_role_type_id is not null")
  end

  def self.area_subquery
    session_table = Session.arel_table
    areas_list = Session.area_list.as('areas_list')
    [
      session_table.create_join(
        areas_list,
        session_table.create_on(
          areas_list[:session_id].eq(session_table[:id])
        ),
        Arel::Nodes::OuterJoin
      )
    ]
  end

  def self.sessions_and_participant_count
    format = Format.find_by(name: 'Panel')
    active_roles = SessionAssignmentRoleType.where("role_type = 'participant' and (name != 'Invisible' and name != 'Reserve')")
    sessions = Session.arel_table
    session_assignments = SessionAssignment.arel_table

    sessions.project(sessions[:id], session_assignments[:id].count.as('nbr_assignments'))
      .join(session_assignments, Arel::Nodes::OuterJoin).on(sessions[:id].eq(session_assignments[:session_id]))
      .where(
        sessions[:format_id].eq(format.id).and(
          session_assignments[:session_assignment_role_type_id].not_eq(nil).and(
            session_assignments[:session_assignment_role_type_id].in(active_roles.collect{|a| a.id})
          )
        )
      )
      .group('sessions.id')
  end
end
