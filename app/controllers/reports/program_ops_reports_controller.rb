class Reports::ProgramOpsReportsController < ApplicationController
  around_action :set_timezone

  def virtual_people
    authorize SessionAssignment, policy_class: Reports::ProgramOpsReportPolicy

    moderator = SessionAssignmentRoleType.find_by(name: 'Moderator')
    participant = SessionAssignmentRoleType.find_by(name: 'Participant')

    assignments = PublishedSessionAssignment
                    .includes(:person, :session_assignment_role_type, :published_session)
                    .where("session_assignment_role_type_id in (?)", [moderator.id, participant.id])
                    .order("people.published_name")

    workbook = FastExcel.open(constant_memory: true)
    worksheet = workbook.add_worksheet("Virtual Participants")

    worksheet.append_row(
      [
        'Published Name',
        'Name',
        'Is Virtual',
        'Primary Email'
      ]
    )

    group_assignments = assignments.group_by {|a| a.person}
    group_assignments.each do |person, grouped|
      row = [
        person.published_name,
        person.name,
        grouped.reduce(false){|res, a| res || (a.published_session.environment == 'virtual')} ? 'Yes' : 'No', # grouped contains virtual
        person.primary_email.email
      ]

      person.email_addresses.each do |addr|
        next if addr == person.primary_email

        row.concat [addr.email]
      end

      worksheet.append_row(row)
    end

    send_data workbook.read_string,
              filename: "VirtualParticipants-#{Time.now.strftime('%m-%d-%Y')}.xlsx",
              disposition: 'attachment'
  end

  def session_minors
    authorize Session, policy_class: Reports::ProgramOpsReportPolicy

    sessions = SessionService
                 .draft_sessions
                 .includes(:age_restriction)


    workbook = FastExcel.open(constant_memory: true)
    worksheet = workbook.add_worksheet("Session and Minor Info")
    date_time_style = workbook.number_format("d mmm yyyy h:mm")
    styles = [nil, nil, date_time_style]

    worksheet.append_row(
      [
        'Session',
        'Tags',
        'Admin Labels',
        'Description',
        'Start Time',
        'Room',
        'Age Restriction',
        'Minors Participation'
      ]
    )

    sessions.each do |session|
      worksheet.append_row(
        [
          session.title,
          session.tags_array&.join("; "),
          session.labels_array&.join("; "),
          session.description,
          session.start_time ? FastExcel.date_num(session.start_time, session.start_time.in_time_zone.utc_offset) : nil,
          session.room&.name,
          session.age_restriction&.name,
          (session.minors_participation && session.minors_participation.size > 0) ? session.minors_participation.join(', ') : nil
        ],
        styles
      )
    end

    send_data workbook.read_string,
              filename: "SessionAndMinors-#{Time.now.strftime('%m-%d-%Y')}.xlsx",
              disposition: 'attachment'
  end

  def user_privileges
    authorize Person, policy_class: Reports::ProgramOpsReportPolicy

    people = Person.includes(:convention_roles, :application_roles, :primary_email).order(:published_name)

    workbook = FastExcel.open(constant_memory: true)
    worksheet = workbook.add_worksheet("People and Roles")
    date_time_style = workbook.number_format("d mmm yyyy h:mm")

    worksheet.append_row(
      [
        'Primary Email',
        'Published Name',
        'Convention Roles',
        'Recently Logged In At'
        # 'Application Roles'
      ]
    )
    people.each do |person|
      worksheet.append_row(
        [
          person.primary_email&.email,
          person.published_name,
          person.convention_roles.collect{|r| r.role}.join(', '),
          person.current_sign_in_at ? FastExcel.date_num(person.current_sign_in_at, person.current_sign_in_at.in_time_zone.utc_offset) : nil,
          # person.convention_roles.collect{|r| r.application_roles.collect{|r| r.name}}.concat(person.application_roles.collect{|r| r.name}).join(', ')
        ],
        [nil, nil, nil, date_time_style]
      )
    end

    send_data workbook.read_string,
              filename: "UserPrivileges-#{Time.now.strftime('%m-%d-%Y')}.xlsx",
              disposition: 'attachment'
  end

  def room_signs
    authorize SessionAssignment, policy_class: Reports::ProgramOpsReportPolicy

    # Need by room and time
    sessions = SessionService
                 .published_sessions_unordered
                 # .order("rooms.name asc, start_time asc")

    # Room name, Day of week, sessions (title, start time, description, participant list with moderator marker).
    grouped_sessions = sessions.group_by {|s| [s.room, s.start_time.strftime('%A'), s.start_time.strftime('%Y%j')]}
    moderator = SessionAssignmentRoleType.find_by(name: 'Moderator')
    participant = SessionAssignmentRoleType.find_by(name: 'Participant')
    max_sessions = 0

    workbook = FastExcel.open #(constant_memory: true)
    worksheet = workbook.add_worksheet("Room Signs")
    date_time_style = workbook.number_format("d mmm yyyy h:mm")
    styles = [nil, nil, nil, date_time_style]

    worksheet.append_row([]) # For the header

    # one line per room per day
    grouped_sessions.sort{|a,b| (a[0][0].name + a[0][2]) <=> (b[0][0].name + b[0][2]) }.each do |grp, sessions|
      row = [grp[0].name, grp[1]]
      styles = [nil, nil]

      sessions.sort{|a,b| a.start_time <=> b.start_time}.each do |session|
        row.concat [
              session.title,
              session.tags_array&.join("; "),
              session.labels_array&.join("; "),
              session.start_time ? FastExcel.date_num(session.start_time, session.start_time.in_time_zone.utc_offset) : nil,
              ActionView::Base.full_sanitizer.sanitize(session.description),
              session.published_session_assignments.select{|a| a.session_assignment_role_type_id == moderator.id}.collect{|a| a.person.published_name}.join("; "),
              session.published_session_assignments.select{|a| a.session_assignment_role_type_id == participant.id}.collect{|a| a.person.published_name}.join("; "),
        ]
        styles.concat [
          nil, nil, nil, date_time_style, nil, nil, nil
        ]
      end
      max_sessions = sessions.size if sessions.size > max_sessions

      worksheet.append_row(row, styles)
    end

    header = ['Room', 'Day']
    (1..max_sessions).each do |n|
      header.concat ["Title #{n}", "Tags #{n}", "Admin Labels #{n}", "Start Time #{n}", "Description #{n}", "Moderators #{n}", "Participants #{n}"]
    end
    worksheet.write_row(0, header)

    send_data workbook.read_string,
              filename: "RoomSigns#{Time.now.strftime('%m-%d-%Y')}.xlsx",
              disposition: 'attachment'
  end

  def sign_up_sessions
    authorize SessionAssignment, policy_class: Reports::ProgramOpsReportPolicy

    sessions = SessionService.draft_sessions.where('require_signup = true')

    workbook = FastExcel.open #(constant_memory: true)
    worksheet = workbook.add_worksheet("Sessions requiring Signups")
    date_time_style = workbook.number_format("d mmm yyyy h:mm")

    styles = [nil, nil, nil, date_time_style ]

    worksheet.append_row(
      [
        'Session',
        'Description',
        'Room',
        'Start Time',
        'Duration',
        'Format',
        'Participants',
        'Environment',
        'Max Signups'
      ]
    )

    sessions.each do |session|
      worksheet.append_row(
        [
          session.title,
          session.description,
          session.room&.name,
          session.start_time ? FastExcel.date_num(session.start_time, session.start_time.in_time_zone.utc_offset) : nil,
          session.duration,
          session.format&.name,
          session.participant_assignments.collect{|pa| pa.person.published_name}.join(";\n"),
          session.environment,
          session.audience_size
        ],
        styles
      )
    end

    send_data workbook.read_string,
              filename: "SessionRequiringSignup-#{Time.now.strftime('%m-%d-%Y')}.xlsx",
              disposition: 'attachment'
  end

  def table_tents
    authorize SessionAssignment, policy_class: Reports::ProgramOpsReportPolicy

    sessions = SessionService.published_sessions
    moderator = SessionAssignmentRoleType.find_by(name: 'Moderator')
    participant = SessionAssignmentRoleType.find_by(name: 'Participant')

    workbook = FastExcel.open #(constant_memory: true)
    worksheet = workbook.add_worksheet("Table Tents")
    date_time_style = workbook.number_format("d mmm yyyy h:mm")

    styles = [nil, nil, date_time_style, nil, nil, nil, nil, nil,]

    worksheet.append_row(
      [
        'Session',
        'Room',
        'Start Time',
        'Published Name',
        'Description',
        'Participant Notes',
        'Moderators',
        'Participants'
      ]
    )

    sessions.each do |session|
      session.published_session_assignments.each do |pa|
        worksheet.append_row(
          [
            session.short_title || session.title,
            session.room&.name,
            FastExcel.date_num(session.start_time, session.start_time.in_time_zone.utc_offset),
            pa.person.published_name,
            ActionView::Base.full_sanitizer.sanitize(session.description),
            session.participant_notes,
            session.published_session_assignments.role(moderator).collect{|p| "#{p.person.published_name}#{p.person.pronouns && !p.person.pronouns.empty? ? ' (' + p.person.pronouns + ')' : ''}" }.join(",\n"),
            session.published_session_assignments.role(participant).collect{|p| "#{p.person.published_name}#{p.person.pronouns && !p.person.pronouns.empty? ? ' (' + p.person.pronouns + ')' : ''}" }.join(",\n")
          ],
          styles
        )
      end
    end

    send_data workbook.read_string,
              filename: "TableTents-#{Time.now.strftime('%m-%d-%Y')}.xlsx",
              disposition: 'attachment'
  end

  def back_of_badge
    authorize SessionAssignment, policy_class: Reports::ProgramOpsReportPolicy

    reserve = SessionAssignmentRoleType.find_by(name: 'Reserve')
    assignments = SessionAssignment
                    .includes(:person, :session_assignment_role_type, :session)
                    .where("sessions.start_time is not null and sessions.room_id is not null")
                    .where("sessions.status != 'draft' and sessions.status != 'dropped'")
                    .where("session_assignments.session_assignment_role_type_id not in (?)", [reserve.id])
                    .where("people.con_state not in (?)", ['declined', 'rejected'])
                    .order("people.published_name, sessions.start_time asc")


    workbook = FastExcel.open #(constant_memory: true)
    worksheet = workbook.add_worksheet("Back of Badge")
    date_time_style = workbook.number_format(EXCEL_NBR_FORMAT)

    worksheet.append_row([]) # For the header

    group_assignments = assignments.group_by {|a| a.person}
    max_sessions = 0
    group_assignments.each do |person, grouped|
      next if person.attendance_type == 'virtual'

      row = [
        person.published_name
      ]
      styles = [nil]

      grouped.each do |assignment|
        title = assignment.session.short_title || assignment.session.title
        row.concat [
          assignment.session.title,
          title.truncate(30),
          assignment.session.start_time ? FastExcel.date_num(assignment.session.start_time, assignment.session.start_time.in_time_zone.utc_offset) : nil,
          "#{assignment.session.duration}m",
          assignment.session.room&.name,
          assignment.session.format&.name,
          assignment.session_assignment_role_type&.name
        ]
        styles.concat [
          nil, nil, date_time_style, nil, nil, nil, nil
        ]
      end
      max_sessions = grouped.size if grouped.size > max_sessions

      worksheet.append_row(row, styles)
    end

    header = ['Published Name']
    (0..max_sessions).each do |n|
      header.concat ["Title #{n+1}", "Truncated Title #{n+1}", "Start Time #{n+1}", "Duration #{n+1}", "Room #{n+1}", "Format #{n+1}", "Role #{n+1}"]
    end
    worksheet.write_row(0, header)

    send_data workbook.read_string,
              filename: "BackOfBadge-#{Time.now.strftime('%m-%d-%Y')}.xlsx",
              disposition: 'attachment'
  end
end
