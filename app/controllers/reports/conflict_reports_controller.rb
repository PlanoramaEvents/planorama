class Reports::ConflictReportsController < ApplicationController
  around_action :set_timezone

  def person_exclusion_conflicts
    authorize SessionAssignment, policy_class: Reports::ConflictReportPolicy

    conflicts_table = ::Conflicts::PersonExclusionConflict.arel_table
    subquery = Session.area_list.as('areas_list')

    joins = [
      conflicts_table.create_join(
        subquery,
        conflicts_table.create_on(
          subquery[:session_id].eq(conflicts_table[:session_id])
        ),
        Arel::Nodes::OuterJoin
      )
    ]

    conflicts = Conflicts::PersonExclusionConflict.select(
                  ::Conflicts::PersonExclusionConflict.arel_table[Arel.star],
                  'areas_list.area_list'
                )
                .joins(joins)
                .includes(
                  :person, :session, :exclusion, :excluded_session
                )
                .where("session_assignment_name in ('Moderator', 'Participant', 'Invisible')")

    workbook = FastExcel.open(constant_memory: true)
    worksheet = workbook.add_worksheet("Person vs Exclusion")

    worksheet.append_row(
      [
        'Name',
        'Pub Name',
        'Person Status',
        'Session',
        'Area',
        'Start Time',
        'Duration',
        'Conflict Session',
        'Conflict Start Time'
      ]
    )
    date_time_style = workbook.number_format("d mmm yyyy h:mm")
    styles = [
      nil, nil, nil, nil, nil, date_time_style,
      nil, nil, date_time_style
    ]

    conflicts.each do |conflict|
      worksheet.append_row(
        [
          conflict.person.name,
          conflict.person.published_name,
          conflict.person.con_state,
          conflict.session.title,
          conflict.area_list.join('; '),
          FastExcel.date_num(conflict.session.start_time, conflict.session.start_time.in_time_zone.utc_offset),
          conflict.session.duration,
          conflict.excluded_session.title,
          FastExcel.date_num(conflict.excluded_session.start_time, conflict.excluded_session.start_time.in_time_zone.utc_offset)
        ],
        styles
      )
    end

    send_data workbook.read_string,
              filename: "PeopleScheduledAgainstConflictItems#{Time.now.strftime('%m-%d-%Y')}.xlsx",
              disposition: 'attachment'
  end

  def back_to_back_to_back
    authorize SessionAssignment, policy_class: Reports::ConflictReportPolicy
    conflicts_table = Arel::Table.new(Conflicts::PersonBackToBackToBack.table_name)
    subquery = Session.area_list.as('areas_list')
    middle_subquery = Session.area_list.as('middle_areas_list')
    conflict_subquery = Session.area_list.as('conflict_areas_list')

    joins = [
      conflicts_table.create_join(
        subquery,
        conflicts_table.create_on(
          subquery[:session_id].eq(conflicts_table[:session_id])
        ),
        Arel::Nodes::OuterJoin
      ),
      conflicts_table.create_join(
        middle_subquery,
        conflicts_table.create_on(
          middle_subquery[:session_id].eq(conflicts_table[:middle_session_id])
        ),
        Arel::Nodes::OuterJoin
      ),
      conflicts_table.create_join(
        conflict_subquery,
        conflicts_table.create_on(
          conflict_subquery[:session_id].eq(conflicts_table[:conflict_session_id])
        ),
        Arel::Nodes::OuterJoin
      )
    ]

    conflicts = Conflicts::PersonBackToBackToBack.select(
      ::Conflicts::PersonBackToBackToBack.arel_table[Arel.star],
      'areas_list.area_list',
      'middle_areas_list.area_list as middle_areas_list',
      'conflict_areas_list.area_list as conflict_areas_list'
    )
    .includes(
      :person,
      :session, :middle_session, :conflict_session,
      :room, :middle_room, :conflict_room
    )
    .joins(joins)
    .where("session_assignment_name is null or session_assignment_name in ('Moderator', 'Participant', 'Invisible')")
    .where("middle_session_assignment_name is null or middle_session_assignment_name in ('Moderator', 'Participant', 'Invisible')")
    .where("conflict_session_assignment_name is null or conflict_session_assignment_name in ('Moderator', 'Participant', 'Invisible')")
    .order('people.published_name asc, start_time asc')

    #
    workbook = FastExcel.open(constant_memory: true)
    worksheet = workbook.add_worksheet("Back to Back to Back")

    worksheet.append_row(
      [
        'Name',
        'Pub Name',
        'Session',
        'Area',
        'Time',
        'Room',

        'Conflict Session',
        'Conflict Area',
        'Conflict Time',
        'Conflict Room',

        'Conflict Session',
        'Conflict Area',
        'Conflict Time',
        'Conflict Room',
        'Reason'
      ]
    )
    date_time_style = workbook.number_format("d mmm yyyy h:mm")
    styles = [
      nil, nil,
      nil, nil, date_time_style, nil,
      nil, nil, date_time_style, nil,
      nil, nil, date_time_style, nil,
      nil
    ]

    conflicts.each do |conflict|
      worksheet.append_row(
        [
          conflict.person.name,
          conflict.person.published_name,

          conflict.session.title,
          conflict.area_list.join('; '),
          FastExcel.date_num(conflict.session.start_time, conflict.session.start_time.in_time_zone.utc_offset),
          conflict.room.name,

          conflict.middle_session.title,
          conflict.middle_areas_list.join('; '),
          FastExcel.date_num(conflict.middle_session.start_time, conflict.middle_session.start_time.in_time_zone.utc_offset),
          conflict.middle_room.name,

          conflict.conflict_session.title,
          conflict.conflict_areas_list.join('; '),
          FastExcel.date_num(conflict.conflict_session.start_time, conflict.conflict_session.start_time.in_time_zone.utc_offset),
          conflict.conflict_room.name,

          'Back to Back to Back'
        ],
        styles
      )
    end

    send_data workbook.read_string,
              filename: "PeopleBackToBackToBack#{Time.now.strftime('%m-%d-%Y')}.xlsx",
              disposition: 'attachment'
  end


  def back_to_back
    authorize SessionAssignment, policy_class: Reports::ConflictReportPolicy
    conflicts = Conflicts::PersonScheduleConflict
                  .where("session_assignment_name is null or session_assignment_name in ('Moderator', 'Participant', 'Invisible')")
                  .where("conflict_session_assignment_name is null or conflict_session_assignment_name in ('Moderator', 'Participant', 'Invisible')")
                  .where(back_to_back: true)
                  .order('published_name asc, conflict_start_time asc')

    workbook = FastExcel.open(constant_memory: true)
    worksheet = workbook.add_worksheet("People Scheduled Back to Back")

    worksheet.append_row(
      [
        'Name',
        'Pub Name',
        'Status',
        'Session',
        'Area',
        'Time',
        'Duration',
        'Room',
        'Conflict Session',
        'Conflict Area',
        'Conflict Time',
        'Conflict Duration',
        'Conflict Room',
        'Reason'
      ]
    )
    date_time_style = workbook.number_format("d mmm yyyy h:mm")
    styles = [nil, nil, nil, nil, nil, date_time_style, nil, nil, nil, nil, date_time_style, nil, nil]

    conflicts.each do |conflict|
      worksheet.append_row(
        [
          conflict.name,
          conflict.published_name,
          conflict.con_state,
          conflict.title,
          conflict.area_list.join('; '),
          FastExcel.date_num(conflict.start_time, conflict.start_time.in_time_zone.utc_offset),
          conflict.duration,
          conflict.room_name,
          conflict.conflict_session_title,
          conflict.conflict_area_list.join('; '),
          FastExcel.date_num(conflict.conflict_start_time, conflict.conflict_start_time.in_time_zone.utc_offset),
          conflict.conflict_duration,
          conflict.conflict_room_name,
          'Back to Back'
        ],
        styles
      )
    end

    send_data workbook.read_string,
              filename: "PeopleBackToBack#{Time.now.strftime('%m-%d-%Y')}.xlsx",
              disposition: 'attachment'
  end

  # Names, time, list of {session name, area, room} tuples
  def people_double_booked
    authorize SessionAssignment, policy_class: Reports::ConflictReportPolicy

    conflicts_table = Arel::Table.new(Conflicts::PersonScheduleConflict.table_name)
    subquery = Session.area_list.as('areas_list')
    conflict_subquery = Session.area_list.as('conflict_areas_list')
    joins = [
      conflicts_table.create_join(
        subquery,
        conflicts_table.create_on(
          subquery[:session_id].eq(conflicts_table[:session_id])
        ),
        Arel::Nodes::OuterJoin
      ),
      conflicts_table.create_join(
        conflict_subquery,
        conflicts_table.create_on(
          conflict_subquery[:session_id].eq(conflicts_table[:conflict_session_id])
        ),
        Arel::Nodes::OuterJoin
      )
    ]

    conflicts = Conflicts::PersonScheduleConflict.select(
                    ::Conflicts::PersonScheduleConflict.arel_table[Arel.star],
                    'areas_list.area_list',
                    'conflict_areas_list.area_list as conflict_areas_list',
                  )
                  .includes(:person, :session, :conflict_session, :room, :conflict_room)
                  .joins(joins)
                  .where("session_assignment_name is null or session_assignment_name in ('Moderator', 'Participant', 'Invisible')")
                  .where("conflict_session_assignment_name is null or conflict_session_assignment_name in ('Moderator', 'Participant', 'Invisible')")
                  .where(back_to_back: false)
                  .order('people.published_name asc, conflict_start_time asc')

    workbook = FastExcel.open(constant_memory: true)
    worksheet = workbook.add_worksheet("People Double Booked")

    worksheet.append_row(
      [
        'Name',
        'Pub Name',
        'Time',
        'Session',
        'Area',
        'Room',
        'Conflict Session',
        'Conflict Area',
        'Conflict Room',
        'Reason'
      ]
    )
    date_time_style = workbook.number_format("d mmm yyyy h:mm")
    styles = [nil, nil, date_time_style, nil, nil, nil, nil, nil]

    conflicts.each do |conflict|
      worksheet.append_row(
        [
          conflict.person.name,
          conflict.person.published_name,
          FastExcel.date_num(conflict.session.start_time, conflict.session.start_time.in_time_zone.utc_offset),
          conflict.session.title,
          conflict.area_list.join('; '),
          conflict.room.name,
          conflict.conflict_session.title,
          conflict.conflict_areas_list.join('; '),
          conflict.conflict_room.name,
          'Double Booked'
        ],
        styles
      )
    end

    send_data workbook.read_string,
              filename: "PeopleDoubleBooked#{Time.now.strftime('%m-%d-%Y')}.xlsx",
              disposition: 'attachment'
  end

  def people_outside_availability
    authorize SessionAssignment, policy_class: Reports::ConflictReportPolicy

    conflicts_table = Arel::Table.new(Conflicts::AvailabilityConflict.table_name)
    subquery = Session.area_list.as('areas_list')
    joins = [
      conflicts_table.create_join(
        subquery,
        conflicts_table.create_on(
          subquery[:session_id].eq(conflicts_table[:session_id])
        ),
        Arel::Nodes::OuterJoin
      )
    ]

    conflicts = Conflicts::AvailabilityConflict.select(
                    ::Conflicts::AvailabilityConflict.arel_table[Arel.star],
                    'areas_list.area_list'
                  )
                  .includes(:session, :person)
                  .joins(joins)
                  .where("session_assignment_name is null or session_assignment_name in ('Moderator', 'Participant', 'Invisible')")
                  .order('people.published_name')


    workbook = FastExcel.open(constant_memory: true)
    worksheet = workbook.add_worksheet("People Outside Availability")

    worksheet.append_row(
      [
        'Name',
        'Pub Name',
        'Session',
        'Areas',
        'Start Time',
        'Reason'
      ]
    )
    date_time_style = workbook.number_format("d mmm yyyy h:mm")
    styles = [nil, nil, nil, nil, date_time_style, nil]

    conflicts.each do |conflict|
      worksheet.append_row(
        [
          conflict.person.name,
          conflict.person.published_name,
          conflict.session.title,
          conflict.area_list.join('; '),
          FastExcel.date_num(conflict.session.start_time, conflict.session.start_time.in_time_zone.utc_offset),
          'Outside Availability'
        ],
        styles
      )
    end

    send_data workbook.read_string,
              filename: "PeopleOutSideAvailability#{Time.now.strftime('%m-%d-%Y')}.xlsx",
              disposition: 'attachment'
  end

  def set_timezone(&block)
    timezone = ConfigService.value('convention_timezone')
    Time.use_zone(timezone, &block)
  end
end
