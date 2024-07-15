class Reports::SessionReportsController < ApplicationController
  around_action :set_timezone

  def session_needs
    authorize SessionAssignment, policy_class: Reports::SessionReportPolicy

    sessions = SessionService.draft_sessions

    workbook = FastExcel.open(constant_memory: true)
    worksheet = workbook.add_worksheet("Session Needs")
    date_time_style = workbook.number_format("d mmm yyyy h:mm")
    styles = [
      nil, date_time_style
    ]

    worksheet.append_row(
      [
        'Session',
        'Start Time',
        'Duration',
        'Room',
        'Environment',
        'Livestreamed',
        'Recorded',
        'Format',
        'Areas',
        'Tags',
        'Admin Labels',
        'Required Room Features/Services', #room_notes
        'Tech/Hotel Notes', #
        'Room Setup' # room_set_id
      ]
    )

    sessions.each do |session|
      worksheet.append_row(
        [
          session.title,
          session.start_time ? FastExcel.date_num(session.start_time, session.start_time.in_time_zone.utc_offset) : nil,
          session.duration,
          session.room&.name,
          session.environment,
          session.streamed ? 'Yes' : 'No',
          session.recorded ? 'Yes' : 'No',
          session.format&.name,
          session.area_list.sort.join(';'),
          session.tags_array&.join("; "),
          session.labels_array&.join("; "),
          session.room_notes,
          session.tech_notes,
          session.room_set&.name
        ],
        styles
      )
    end

    send_data workbook.read_string,
              filename: "SessionNeeds-#{Time.now.strftime('%m-%d-%Y')}.xlsx",
              disposition: 'attachment'
  end

  def streamed_and_recorded
    authorize SessionAssignment, policy_class: Reports::SessionReportPolicy

    sessions = SessionService.draft_sessions

    workbook = FastExcel.open(constant_memory: true)
    worksheet = workbook.add_worksheet("Sessions streamed and recorded")
    date_time_style = workbook.number_format("d mmm yyyy h:mm")
    styles = [
      nil, date_time_style, nil, nil, nil, nil, nil
    ]

    worksheet.append_row(
      [
        'Session',
        'Start Time',
        'Room',
        'Format',
        'Environment',
        'Livestreamed',
        'Recorded',
        'Tags', 
        'Admin Labels'
      ]
    )

    sessions.each do |session|
      worksheet.append_row(
        [
          session.title,
          session.start_time ? FastExcel.date_num(session.start_time, session.start_time.in_time_zone.utc_offset) : nil,
          session.room&.name,
          session.format&.name,
          session.environment,
          session.streamed ? 'Yes' : 'No',
          session.recorded ? 'Yes' : 'No',
          session.tags_array&.join("; "),
          session.labels_array&.join("; ")
        ],
        styles
      )
    end

    send_data workbook.read_string,
              filename: "SessionsStreamedRecorded#{Time.now.strftime('%m-%d-%Y')}.xlsx",
              disposition: 'attachment'
  end

  def daily_grid
    authorize SessionAssignment, policy_class: Reports::SessionReportPolicy

    sessions = SessionService.published_sessions

    workbook = FastExcel.open(constant_memory: true)
    worksheet = workbook.add_worksheet("Assigned Session not Sched")
    date_time_style = workbook.number_format(EXCEL_NBR_FORMAT)
    styles = [
      nil, nil, nil, nil, nil, date_time_style, nil
    ]

    worksheet.append_row(
      [
        'Session',
        'Areas',
        'Tags',
        'Admin Labels',
        'Format',
        'Start Time',
        'Duration',
        'Room'
      ]
    )

    sessions.each do |session|
      worksheet.append_row(
        [
          session.short_title || session.title,
          session.area_list.sort.join(';'),
          session.tags_array&.join("; "),
          session.labels_array&.join("; "),
          session.format&.name,
          session.start_time ? FastExcel.date_num(session.start_time, session.start_time.in_time_zone.utc_offset) : nil,
          session.duration,
          session.room&.name
        ],
        styles
      )
    end

    send_data workbook.read_string,
              filename: "DailyGrid#{Time.now.strftime('%m-%d-%Y')}.xlsx",
              disposition: 'attachment'
  end

  def session_copy_edit_status
    authorize SessionAssignment, policy_class: Reports::SessionReportPolicy

    sessions = ReportsService.all_sessions

    workbook = FastExcel.open(constant_memory: true)
    worksheet = workbook.add_worksheet("Assigned Session not Sched")

    worksheet.append_row(
      [
        'Session',
        'Description',
        'Areas',
        'Tags',
        'Labels',
        'Status',
        'Copy Edited',
        'Scheduled',
        'Visibility'
      ]
    )

    sessions.each do |session|
      worksheet.append_row(
        [
          session.title,
          session.description, # NOTE: there is no mechanism for format HTML for excel so put the desc in and see what happens
          session.area_list.sort.join(';'),
          session.tags_array&.join("; "),
          session.labels_array&.join("; "),
          session.status,
          session.proofed ? 'Y' : 'N',
          session.start_time && session.room_id ? 'Y' : 'N',
          session.is_public? ? 'Visible' : 'Not Visible'
        ]
      )
    end

    send_data workbook.read_string,
              filename: "SessionCopyEditStatue#{Time.now.strftime('%m-%d-%Y')}.xlsx",
              disposition: 'attachment'
  end

  def assigned_sessions_not_scheduled
    authorize SessionAssignment, policy_class: Reports::SessionReportPolicy

    sessions = SessionService.assigned_sessions_not_scheduled

    workbook = FastExcel.open(constant_memory: true)
    worksheet = workbook.add_worksheet("Assigned Session not Sched")

    worksheet.append_row(
      [
        'Session',
        'Areas',
        'Tags',
        'Admin Labels',
        'Moderators',
        'Participants',
        'Invisible',
      ]
    )

    moderator = SessionAssignmentRoleType.find_by(name: 'Moderator')
    participant = SessionAssignmentRoleType.find_by(name: 'Participant')
    invisible = SessionAssignmentRoleType.find_by(name: 'Invisible')
    sessions.each do |session|
      worksheet.append_row(
        [
          session.title,
          session.area_list.sort.join(';'),
          session.tags_array&.join("; "),
          session.labels_array&.join("; "),
          session.session_assignments.select{|a| a.session_assignment_role_type_id == moderator.id}.collect{|a| a.person.published_name}.join(';'),
          session.session_assignments.select{|a| a.session_assignment_role_type_id == participant.id}.collect{|a| a.person.published_name}.join(';'),
          session.session_assignments.select{|a| a.session_assignment_role_type_id == invisible.id}.collect{|a| a.person.published_name}.join(';')
        ]
      )
    end

    send_data workbook.read_string,
              filename: "AssignedSessionsNotScheduled#{Time.now.strftime('%m-%d-%Y')}.xlsx",
              disposition: 'attachment'
  end

  def scheduled_session_no_people
    authorize SessionAssignment, policy_class: Reports::SessionReportPolicy

    sessions = ReportsService.scheduled_session_no_people

    workbook = FastExcel.open(constant_memory: true)
    worksheet = workbook.add_worksheet("Sched Sessions no Participants")
    date_time_style = workbook.number_format("d mmm yyyy h:mm")
    styles = [
      nil, nil, date_time_style, nil
    ]

    worksheet.append_row(
      [
        'Session',
        'Area',
        'Tags',
        'Admin Labels',
        'Start Time',
        'Room'
      ]
    )

    sessions.each do |session|
      worksheet.append_row(
        [
          session.title,
          session.area_list.sort.join(';'),
          session.tags_array&.join("; "),
          session.labels_array&.join("; "),
          session.start_time ? FastExcel.date_num(session.start_time, session.start_time.in_time_zone.utc_offset) : nil,
          session.room.name
        ],
        styles
      )
    end

    send_data workbook.read_string,
              filename: "ScheduledSessionsWithNoPeople#{Time.now.strftime('%m-%d-%Y')}.xlsx",
              disposition: 'attachment'

  end

  def session_with_no_moderator
    authorize SessionAssignment, policy_class: Reports::SessionReportPolicy
    sessions = ReportsService.sessions_with_no_moderator

    workbook = FastExcel.open(constant_memory: true)
    worksheet = workbook.add_worksheet("Sessions no Moderator")
    date_time_style = workbook.number_format("d mmm yyyy h:mm")
    styles = [
      nil, nil, date_time_style, nil, nil, nil
    ]

    worksheet.append_row(
      [
        'Session',
        'Area',
        'Tags',
        'Admin Labels',
        'Start Time',
        'Format',
        'People Assigned',
        'Reserved'
      ]
    )

    moderator = SessionAssignmentRoleType.find_by(name: 'Moderator')
    participant = SessionAssignmentRoleType.find_by(name: 'Participant')
    reserve = SessionAssignmentRoleType.find_by(name: 'Reserve')
    sessions.each do |session|
      worksheet.append_row(
        [
          session.title,
          session.area_list.sort.join(';'),
          session.tags_array&.join("; "),
          session.labels_array&.join("; "),
          session.start_time ? FastExcel.date_num(session.start_time, session.start_time.in_time_zone.utc_offset) : nil,
          session.format&.name,
          session.session_assignments.select{|a| a.session_assignment_role_type_id == participant.id}.collect{|a| a.person.published_name}.join(';'),
          session.session_assignments.select{|a| a.session_assignment_role_type_id == reserve.id}.collect{|a| a.person.published_name}.join(';')
        ],
        styles
      )
    end

    send_data workbook.read_string,
              filename: "SessionsWithoutModerator#{Time.now.strftime('%m-%d-%Y')}.xlsx",
              disposition: 'attachment'
  end

  def non_accepted_on_schedule
    authorize SessionAssignment, policy_class: Reports::SessionReportPolicy

    people_sessions = SessionService.person_schedule
                        .where("session_assignment_name in ('Moderator', 'Participant', 'Invisible')")
                        .where("con_state not in ('accepted')")
                        .where("start_time is not null and room_id is not null")
                        .order('name', 'start_time', 'title')

    workbook = FastExcel.open(constant_memory: true)
    worksheet = workbook.add_worksheet("Non-Accepted on Schedule")

    worksheet.append_row(
      [
        'Name',
        'Published Name',
        'Participant Status',
        'Session',
        'Area',
        'Tags',
        'Admin Labels'
      ]
    )

    people_sessions.each do |sa|
      worksheet.append_row(
        [
          sa.name,
          sa.published_name,
          sa.con_state,
          sa.title,
          sa.area_list.join('; '),
          sa.tags_array&.join("; "),
          sa.labels_array&.join("; ")
        ]
      )
    end

    send_data workbook.read_string,
              filename: "NonAcceptedPeopleOnSessions#{Time.now.strftime('%m-%d-%Y')}.xlsx",
              disposition: 'attachment'
  end

  def invited_accepted_not_scheduled
    authorize SessionAssignment, policy_class: Reports::SessionReportPolicy

    people = Person.where(
                "id not in (?)",
                PersonSchedule
                  .where("session_assignment_name in ('Moderator', 'Participant', 'Invisible')")
                  .where("start_time is not null and room_id is not null")
                  .pluck('person_id')
              ).where(
                "con_state in (?)",
                ['invite_pending', 'invited', 'accepted']
              ).order('name')


    workbook = FastExcel.open(constant_memory: true)
    worksheet = workbook.add_worksheet("Not Scheduled")

    worksheet.append_row(
      [
        'Name',
        'Published Name',
        'Participant Status',
        'Attendance Type',
        'Bio'
      ]
    )

    people.each do |person|
      worksheet.append_row(
        [
          person.name,
          person.published_name,
          person.con_state,
          person.attendance_type,
          person.bio
        ]
      )
    end

    send_data workbook.read_string,
            filename: "InvitedAcceptedNotScheduled#{Time.now.strftime('%m-%d-%Y')}.xlsx",
            disposition: 'attachment'
  end

  def participants_over_session_limits
    authorize SessionAssignment, policy_class: Reports::SessionReportPolicy

    workbook = FastExcel.open(constant_memory: true)
    worksheet = workbook.add_worksheet("Participants too Many Sessions")
    people = ::ReportsService.participant_and_session_limits

    worksheet.append_row(
      [
        'Name',
        'Published Name',
        'Participant Status',
        'Day',
        'Session Count',
        "Person's Limit"
      ]
    )

    people.each do |person|
      worksheet.append_row(
        [
          person.name,
          person.published_name,
          person.con_state,
          person.day ? person.day : 'All',
          person.session_count,
          person.max_sessions
        ]
      )
    end

    send_data workbook.read_string,
              filename: "Participants_with_too_many_sessions#{Time.now.strftime('%m-%d-%Y')}.xlsx",
              disposition: 'attachment'
  end

  def participants_over_con_session_limits
    authorize SessionAssignment, policy_class: Reports::SessionReportPolicy

    workbook = FastExcel.open(constant_memory: true)
    worksheet = workbook.add_worksheet("Too Many Sessions for Con")
    people = ::ReportsService.participant_and_con_session_limits

    worksheet.append_row(
      [
        'Name',
        'Published Name',
        'Participant Status',
        'Session Count',
        'Con Limit'
      ]
    )

    people.each do |person|
      worksheet.append_row(
        [
          person.name,
          person.published_name,
          person.con_state,
          person.session_count,
          6
        ]
      )
    end

    send_data workbook.read_string,
              filename: "Participants_with_too_many_sessions_for_con#{Time.now.strftime('%m-%d-%Y')}.xlsx",
              disposition: 'attachment'
  end

  def panels_with_too_few_people
    authorize SessionAssignment, policy_class: Reports::SessionReportPolicy

    workbook = FastExcel.open(constant_memory: true)
    worksheet = workbook.add_worksheet("Panels with too Few People")
    date_time_style = workbook.number_format("d mmm yyyy h:mm")
    styles = [
      nil, nil, date_time_style, nil, nil, nil, nil
    ]
    sessions = ::ReportsService.panels_with_too_few_people

    # Session name, Area, session start, participant count, participant count lower bound, list of participants
    worksheet.append_row(
      [
        'Session',
        'Areas',
        'Tags',
        'Admin Labels',
        'Start Time',
        'Participant Count',
        'Participant Count Lower Bound',
        'Participants',
        'Moderators'
      ]
    )

    moderator = SessionAssignmentRoleType.find_by(name: 'Moderator')
    participant = SessionAssignmentRoleType.find_by(name: 'Participant')
    sessions.each do |session|
      worksheet.append_row(
        [
          session.title,
          session.area_list.sort.join(';'),
          session.tags_array&.join("; "),
          session.labels_array&.join("; "),
          session.start_time ? FastExcel.date_num(session.start_time, session.start_time.in_time_zone.utc_offset) : '',
          session.nbr_assignments,
          3,
          session.session_assignments.select{|a| a.session_assignment_role_type_id == participant.id}.collect{|a| a.person.published_name}.join(';'),
          session.session_assignments.select{|a| a.session_assignment_role_type_id == moderator.id}.collect{|a| a.person.published_name}.join(';')
        ],
        styles
      )
    end

    send_data workbook.read_string,
              filename: "Panels_With_Too_Few_People_#{Time.now.strftime('%m-%d-%Y')}.xlsx",
              disposition: 'attachment'
  end

  def panels_with_too_many_people
    authorize SessionAssignment, policy_class: Reports::SessionReportPolicy

    workbook = FastExcel.open(constant_memory: true)
    worksheet = workbook.add_worksheet("Panels with too Many People")
    date_time_style = workbook.number_format("d mmm yyyy h:mm")
    styles = [
      nil, nil, date_time_style, nil, nil, nil
    ]

    sessions = ::ReportsService.panels_with_too_many_people

    # Session name, Area, session start, participant count, participant count lower bound, list of participants
    worksheet.append_row(
      [
        'Session',
        'Areas',
        'Tags',
        'Admin Labels',
        'Start Time',
        'Participant Count',
        'Participant Count Upper Bound',
        'Participants',
        'Moderators'
      ]
    )

    # has_many :submissions
    moderator = SessionAssignmentRoleType.find_by(name: 'Moderator')
    participant = SessionAssignmentRoleType.find_by(name: 'Participant')
    sessions.each do |session|
      worksheet.append_row(
        [
          session.title,
          session.area_list.sort.join(';'),
          session.tags_array&.join("; "),
          session.labels_array&.join("; "),
          session.start_time ? FastExcel.date_num(session.start_time, session.start_time.in_time_zone.utc_offset) : nil,
          session.nbr_assignments,
          6,
          session.session_assignments.select{|a| a.session_assignment_role_type_id == participant.id}.collect{|a| a.person.published_name}.join(';'),
          session.session_assignments.select{|a| a.session_assignment_role_type_id == moderator.id}.collect{|a| a.person.published_name}.join(';')
        ],
        styles
      )
    end

    send_data workbook.read_string,
              filename: "Panels_With_Too_Many_People_#{Time.now.strftime('%m-%d-%Y')}.xlsx",
              disposition: 'attachment'
  end
end
