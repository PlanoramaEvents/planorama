class ReportsController < ApplicationController
  around_action :set_timezone

  def schedule_accpetance
    authorize SessionAssignment, policy_class: ReportPolicy

    people = ReportsService.approvals

    workbook = FastExcel.open(constant_memory: true)
    worksheet = workbook.add_worksheet("Approvals")
    date_time_style = workbook.number_format("d mmm yyyy h:mm")
    styles = [
              nil, nil, nil, nil, nil,
              nil, nil, date_time_style,
              nil, nil, date_time_style
            ]

    worksheet.append_row(
      [
        'Name',
        'Published Name',
        'Primary Email',
        'Attendance Type',
        'Participant Status',
        "Draft Approval",
        "Draft Comments",
        "Draft Edited Time",
        "Firm Approval",
        "Firm Comments",
        "Firm Edited Time"
      ]
    )

    # has_many :submissions
    people.each do |person|
      # where workflow state = 'draft'
      draft_approval = person.person_schedule_approvals.find{|a| a.schedule_workflow.state == 'draft'}
      # where workflow state = 'firm'
      firm_approval = person.person_schedule_approvals.find{|a| a.schedule_workflow.state == 'firm'}
      worksheet.append_row(
        [
          person.name,
          person.published_name,
          person.primary_email&.email,
          person.attendance_type,
          person.con_state,
          draft_approval ? draft_approval.approved : 'not_set',
          draft_approval && draft_approval.approved == 'no' ? draft_approval&.comments : '',
          draft_approval && draft_approval.approved != 'not_set' ? draft_approval&.updated_at : '',
          firm_approval ? firm_approval.approved : 'not_set',
          firm_approval && firm_approval.approved == 'no' ? firm_approval&.comments : '',
          firm_approval && firm_approval.approved != 'not_set' ? firm_approval&.updated_at : ''
        ],
        styles
      )
    end

    send_data workbook.read_string,
              filename: "DraftAndScheduleAccpetance#{Time.now.strftime('%m-%d-%Y')}.xlsx",
              disposition: 'attachment'
  end

  #
  # Name
  # Published Name (i.e. Pseudonym)
  # Email
  # Attendance Type (Attending In-Person, Virtual or Hybrid)
  # Participant Status (Applied, Vetted, .....)
  # Program Participant Survey "Created At" field
  #
  def people_and_submissions
    authorize SessionAssignment, policy_class: ReportPolicy

    people = Person.includes(
      {submissions: :survey},
      :primary_email
    )
    .references(
      :submissions
    )
    .where("people.con_state not in (?)", ['declined', 'rejected'])
    .where("survey_submissions.id in (?)", Survey::Response.select(:submission_id).distinct)
    .order("people.name")

    workbook = FastExcel.open(constant_memory: true)
    worksheet = workbook.add_worksheet("People and Submissions")

    worksheet.append_row(
      [
        'Name',
        'Published Name',
        'Primary Email',
        'Attendance Type',
        'Participant Status',
        "Surveys Taken"
      ]
    )

    # has_many :submissions
    people.each do |person|
      worksheet.append_row(
        [
          person.name,
          person.published_name,
          person.primary_email&.email,
          person.attendance_type,
          person.con_state,
          person.submissions.collect{ |s| "#{s.survey.name}: #{s.created_at}" }.join(";\n")
        ]
      )
    end

    send_data workbook.read_string,
              filename: "PeopleAndSubmissions_#{Time.now.strftime('%m-%d-%Y')}.xlsx",
              disposition: 'attachment'
  end

  # Sessions that are assigned - this should only return if at least one of the three below assigned status have anyone assigned to it
  #
  #     Area(s)
  #     Title
  #     Moderator(s) - The names of people assigned as moderator
  #     Participants - The names of people assigned as participants
  #     Reserve - The names of people selected as reserved
  #
  def sessions_with_participants
    authorize SessionAssignment, policy_class: ReportPolicy

    sessions = SessionService.sessions
                .eager_load(:areas, {session_assignments: [:person]})
                .where("session_assignments.session_assignment_role_type_id is not null")
                .order('sessions.title')

    workbook = FastExcel.open(constant_memory: true)
    worksheet = workbook.add_worksheet("Sessions With Participants")

    worksheet.append_row(
      [
        'Session',
        'Session Type/Format',
        'Areas',
        'Tags',
        'Admin Labels',
        'Moderators',
        'Participants',
        'Reserves',
        'Scehduled'
      ]
    )

    moderator = SessionAssignmentRoleType.find_by(name: 'Moderator')
    participant = SessionAssignmentRoleType.find_by(name: 'Participant')
    reserve = SessionAssignmentRoleType.find_by(name: 'Reserve')
    sessions.each do |session|
      worksheet.append_row(
        [
          session.title,
          session.format&.name,
          session.area_list.sort.join(';'),
          session.tags_array&.join("; "),
          session.labels_array&.join("; "),
          session.session_assignments.select{|a| a.session_assignment_role_type_id == moderator.id}.collect{|a| a.person.published_name}.join(';'),
          session.session_assignments.select{|a| a.session_assignment_role_type_id == participant.id}.collect{|a| a.person.published_name}.join(';'),
          session.session_assignments.select{|a| a.session_assignment_role_type_id == reserve.id}.collect{|a| a.person.published_name}.join(';'),
          session.start_time && session.room_id ? 'Y' : 'N'
        ]
      )
    end

    send_data workbook.read_string,
              filename: "SessionsWithParticipants#{Time.now.strftime('%m-%d-%Y')}.xlsx",
              disposition: 'attachment'

  end

  # Schedule by room and time - this should only return sessions that have a spacetime
  #
  #     Room name
  #     Session start time (CDT)
  #     Session Title
  #     Area(s)
  #     Moderator & visible participants (published_name)
  #
  #  sort by room then time then session title
  #
  def schedule_by_room_then_time
    authorize SessionAssignment, policy_class: ReportPolicy

    sessions = SessionService.sessions
                .references(:room)
                .eager_load(:areas, :room, {session_assignments: [:person]})
                .where("sessions.room_id is not null and sessions.start_time is not null")
                .order('rooms.sort_order', 'sessions.start_time', 'sessions.title')

    workbook = FastExcel.open(constant_memory: true)
    worksheet = workbook.add_worksheet("Schedule by Room then Time")

    worksheet.append_row(
      [
        'Session',
        'Area',
        'Tags',
        'Labels',
        'Start Time',
        'Session Duration',
        'Room',
        'Moderator',
        'Assigned'
      ]
    )
    date_time_style = workbook.number_format("d mmm yyyy h:mm")
    styles = [nil, nil, date_time_style, nil, nil, nil, nil]
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
          FastExcel.date_num(session.start_time, session.start_time.in_time_zone.utc_offset),
          session.duration,
          session.room.name,
          session.session_assignments.
            select{|a| [moderator.id].include?(a.session_assignment_role_type_id)}.
            collect{|s| s.person.published_name}.join('; '),
          session.session_assignments.
            select{|a| [participant.id].include?(a.session_assignment_role_type_id)}.
            collect{|s| s.person.published_name}.join('; ')
        ],
        styles
      )
    end

    send_data workbook.read_string,
              filename: "ScheduleByRoomThenTime#{Time.now.strftime('%m-%d-%Y')}.xlsx",
              disposition: 'attachment'
  end


  # Schedule by person - this should only return sessions where person is assigned as a moderator or a participant
  # on items that have spacetimes
  #
  #     Name
  #     Published name (ie pseudonym)
  #     Session Name
  #     Area(s)
  #     Session start time (CDT)
  #     Room name
  #     Moderator indicator (Y/N)
  #     Invisible indicator (Y/N) (only for invisible participants)
  #
  #  sort by person (alpha asc) then by start time (asc) then by session title
  #
  def schedule_by_person
    authorize SessionAssignment, policy_class: ReportPolicy

    # 
    people_sessions = SessionService.person_schedule
      .includes(:room).references(:room)
      .where("session_assignment_name in (?)", ['Moderator', 'Participant', "Invisible"])
      .where("start_time is not null and room_id is not null")
      .where("person_schedules.con_state not in (?)", ['declined', 'rejected'])
      .order('person_schedules.name', 'start_time', 'title')

    workbook = FastExcel.open(constant_memory: true)
    worksheet = workbook.add_worksheet("Schedule by Participant")

    worksheet.append_row(
      [
        'Name',
        'Published Name',
        'Participant Status',
        'Session',
        'Area',
        'Tags',
        'Admin Labels',
        'Start Time',
        'Room',
        'Moderator',
        'Invisible',
      ]
    )

    date_time_style = workbook.number_format("d mmm yyyy h:mm")
    styles = [nil, nil, nil, nil, nil, date_time_style, nil, nil, nil]
    people_sessions.each do |sa|
      worksheet.append_row(
        [ sa.name,
          sa.published_name,
          sa.con_state,
          sa.title,
          sa.area_list.join('; '),
          sa.tags_array&.join("; "),
          sa.labels_array&.join("; "),
          FastExcel.date_num(sa.start_time, sa.start_time.in_time_zone.utc_offset),
          sa.room.name,
          if sa.session_assignment_name == 'Moderator' then 'Y' else 'N' end,
          if sa.session_assignment_name == 'Invisible' then 'Y' else 'N' end
        ],
        styles
      )
    end

    send_data workbook.read_string,
              filename: "ScheduleByParticipant#{Time.now.strftime('%m-%d-%Y')}.xlsx",
              disposition: 'attachment'
  end

  # Assigned session by participant - this should only return if the person is assigned as a moderator or a participant
  #
  #     Name
  #     Item title
  #     If they are assigned as a moderator or not for that item
  def assigned_sessions_by_participant
    authorize SessionAssignment, policy_class: ReportPolicy

    people = Person.includes(
      {session_assignments: [:session, :session_assignment_role_type]}
    ).references(
      {session_assignments: :session}
    ).where(
      "session_assignments.session_assignment_role_type_id is not null"
    ).where("people.con_state not in (?)", ['declined', 'rejected']).order("people.name")

    workbook = FastExcel.open(constant_memory: true)
    worksheet = workbook.add_worksheet("Assigned Sessions")

    worksheet.append_row(
      [
        'Name',
        'Published Name',
        'Participant Status',
        'Attendance Type',
        'Match Status',
        'Session',
        'Role',
        'Scheduled',
        'Tags',
        'Admin Labels'
      ]
    )

    people.each do |person|
      person.session_assignments.each do |assignment|
        worksheet.append_row(
          [
            person.name,
            person.published_name,
            person.con_state,
            person.attendance_type,
            person.reg_match,
            assignment.session.title,
            assignment.session_assignment_role_type.name,
            assignment.session.start_time && assignment.session.room_id ? 'Y' : 'N',
            assignment.session.tag_list.join("; "),
            assignment.session.label_list.join("; ")
          ]
        )
      end
    end

    send_data workbook.read_string,
              filename: "AssignedSessionsByPerson_#{Time.now.strftime('%m-%d-%Y')}.xlsx",
              disposition: 'attachment'
  end

  #
  #
  #
  def participant_availabilities
    people = Person.includes(
      :availabilities,
      :session_limits,
      :person_exclusions,
      :exclusions
    ).references(
      :availabilities,
      :session_limits,
      :person_exclusions
    ).where(
      "availabilities.person_id is not null OR session_limits.person_id is not null OR person_exclusions.person_id is not null"
    ).where(
      "people.con_state not in (?)", ['declined','rejected']
    )
    .where("people.con_state not in (?)", ['declined', 'rejected'])

    workbook = FastExcel.open(constant_memory: true)
    worksheet = workbook.add_worksheet("Participant Availability")

    worksheet.append_row(
      [
        'Name',
        'Published Name',
        'Participant Status',
        'Attendance Type',
        'Availabilities',
        'Limits',
        'Exclusions',
        'Availability Notes'
      ]
    )

    people.each do |person|
      worksheet.append_row(
        [
          person.name,
          person.published_name,
          person.con_state,
          person.attendance_type,
          # TODO: format time ....
          person.availabilities.order('start_time').collect{|av| "#{av.start_time.strftime('%Y-%m-%d %H:%M %Z')} to #{av.end_time.strftime('%Y-%m-%d %H:%M %Z')}" }.join(";\n"),
          person.session_limits.order('day').collect{|l| "#{l.day ? l.day : 'Global'}: #{l.max_sessions}" }.join(";\n"),
          person.exclusions.collect{|e| "#{e.title}"}.join(";\n"),
          person.availability_notes
        ]
      )

    end

    send_data workbook.read_string,
              filename: "ParticipantAvailabilities_#{Time.now.strftime('%m-%d-%Y')}.xlsx",
              disposition: 'attachment'
  end

  # By participant
  # Name
  # What they signed up for
  # How they ranked it
  # What they wrote in the free text box
  # (Nice to have) Area
  def participant_selections
    authorize SessionAssignment, policy_class: ReportPolicy

    assignments = SessionAssignment
                    .joins(:person)
                    .includes([{session: :areas}, :person, :session_assignment_role_type])
                    .where(interested: true)
                    .where("people.con_state not in (?)", ['declined', 'rejected'])
                    .order("people.name")

    workbook = FastExcel.open(constant_memory: true)
    worksheet = workbook.add_worksheet("Participant Selections")

    worksheet.append_row(
      [
        'Name',
        'Published Name',
        'Participant Status',
        'Session',
        'Ranking',
        'Ranking Notes',
        'Areas',
        'Tags',
        'Admin Labels',
        'Assigned',
        'Scheduled'
      ]
    )
    assignments.each do |assignment|
      worksheet.append_row(
        [
          assignment.person.name,
          assignment.person.published_name,
          assignment.person.con_state,
          assignment.session.title,
          assignment.interest_ranking,
          assignment.interest_notes,
          assignment.session.areas.collect(&:name).join("; "),
          assignment.session.tag_list.join("; "),
          assignment.session.label_list.join("; "),
          assignment.session_assignment_role_type && assignment.session_assignment_role_type.role_type == 'participant' &&  ['Moderator', 'Participant'].include?(assignment.session_assignment_role_type.name) ? 'Y' : 'N',
          assignment.session.start_time && assignment.session.room_id ? 'Y' : 'N'
        ]
      )
    end

    send_data workbook.read_string,
              filename: "ParticipantSelections_#{Time.now.strftime('%m-%d-%Y')}.xlsx",
              disposition: 'attachment'
  end

  # By session
  # Title
  # Who has signed up
  # How they ranked it
  # What they wrote in the free text box
  # (Nice to have) Area
  def session_selections
    authorize Session, policy_class: ReportPolicy

    sessions = SessionService.sessions
                .eager_load(:areas, {session_assignments: [:person]})
                .where('session_assignments.interested': true)
                .where("people.con_state not in (?)", ['declined', 'rejected'])
                .order('sessions.title')

    workbook = FastExcel.open(constant_memory: true)
    worksheet = workbook.add_worksheet("Session Selections")

    worksheet.append_row(
      [
        'Title',
        'Who is Interested',
        'Who is Interested (Pub Name)',
        'Participant Status',
        'Ranking',
        'Notes',
        'Areas',
        'Tags',
        'Admin Labels'
      ]
    )

    sessions.each do |session|
      session.session_assignments.each do |assignment|
        worksheet.append_row(
          [
            session.title,
            assignment.person.name,
            assignment.person.published_name,
            assignment.person.con_state,
            assignment.interest_ranking,
            assignment.interest_notes,
            session.areas.collect(&:name).join("; "),
            session.tags_array&.join("; "),
            session.labels_array&.join("; ")
          ]
        )
      end
    end

    send_data workbook.read_string,
              filename: "SessionSelections_#{Time.now.strftime('%m-%d-%Y')}.xlsx",
              disposition: 'attachment'
  end

  # Person with do not assign with - only people with 'do not assign with'
  #
  #     Name
  #     Published name (ie pseudonym)
  #     Session Name
  #     Area(s)
  #     All participants
  #     Do not assign with
  #
  #  sort by person name, session title
  #
  def participant_do_not_assign_with
    authorize SessionAssignment, policy_class: ReportPolicy

    sa_table = Arel::Table.new(SessionAssignment.table_name)
    subquery = Session.area_list.as('areas_list')
    joins = [
      sa_table.create_join(
        subquery,
        sa_table.create_on(
          subquery[:session_id].eq(sa_table[:session_id])
        ),
        Arel::Nodes::OuterJoin
      )
    ]

    people = Person.select(
                ::Person.arel_table[Arel.star],
                'areas_list.area_list'
              )
              .joins({session_assignments: [:person, :session_assignment_role_type]})
              .joins(
                joins
              )
              .eager_load(
                {
                  session_assignments: [
                    {
                      session: [session_assignments: :person]
                    },
                    :person
                  ]
                }
              )
              .where("people.do_not_assign_with is not null and people.do_not_assign_with <> ''")
              .where("session_assignment_role_type.name in (?)", ['Moderator', 'Participant', "Invisible"])
              .where("people.con_state not in (?)", ['declined', 'rejected'])
              .order("people.published_name asc")

    workbook = FastExcel.open(constant_memory: true)
    worksheet = workbook.add_worksheet("Participant Do Not Assign With")

    worksheet.append_row(
      [
        'Name',
        'Published Name',
        'Session',
        'Area',
        'Tags',
        'Admin Labels',
        'Assigned to session',
        'Do not assign with'
      ]
    )

    moderator = SessionAssignmentRoleType.find_by(name: 'Moderator')
    participant = SessionAssignmentRoleType.find_by(name: 'Participant')
    invisible = SessionAssignmentRoleType.find_by(name: 'Invisible')
    people.each do |person|
      person.session_assignments.each do |sa|
        worksheet.append_row(
          [
            person.name,
            person.published_name,
            sa.session.title,
            person.area_list.join('; '),            
            sa.session.tag_list&.join("; "),
            sa.session.label_list&.join("; "),
            sa.session.session_assignments.select{|a| [participant.id, moderator.id, invisible.id].include?(a.session_assignment_role_type_id)}.collect{|s| s.person.published_name}.join('; '),
            person.do_not_assign_with
          ]
        )
      end
    end

    send_data workbook.read_string,
              filename: "ParticipantDoNotAssignWith#{Time.now.strftime('%m-%d-%Y')}.xlsx",
              disposition: 'attachment'
  end
end
