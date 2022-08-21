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

  def back_of_badge
    authorize SessionAssignment, policy_class: Reports::ProgramOpsReportPolicy

    assignments = PublishedSessionAssignment
                    .includes(:person, :session_assignment_role_type, :published_session)
                    .order("people.published_name, published_sessions.start_time asc")


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
        row.concat [
          assignment.session.title,
          assignment.session.title.truncate(30),
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
