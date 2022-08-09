class Reports::PeopleReportsController < ApplicationController
  around_action :set_timezone

  def record_stream_permissions
    authorize Person, policy_class: ReportPolicy

    # People: moderators, participants.  NO INVIS, NO RESEVER

    active_roles = SessionAssignmentRoleType.where("role_type = 'participant' and (name != 'Invisible' and name != 'Reserve')")
    people = Person
      .includes({sessions: :room}, :primary_email)
      .references(:sessions)
      .where("session_assignments.session_assignment_role_type_id not in (select id from session_assignment_role_type where session_assignment_role_type.name = 'Invisible')")
      .where("session_assignments.session_assignment_role_type_id not in (select id from session_assignment_role_type where session_assignment_role_type.name = 'Reserve')")
      .order('people.published_name asc')


    # Person published  names, primary email, attendance type,
    # participant status, permission to stream,
    # exclusions for streaming, permission to record, exclusions to recording,
    # their schedule (in one cell with session title time duration room.  If not possible one line per session will have to do)

    workbook = FastExcel.open(constant_memory: true)
    worksheet = workbook.add_worksheet("Record and Stream Permissions")

    worksheet.append_row(
      [
        'Name',
        'Published Name',
        'Primary Email',
        'Attendance Type',
        'Participant Status',
        'Permission to Stream',
        'Streaming Exceptions',
        'Permission to Record',
        'Recording Exceptions',
        'Schedule'
      ]
    )

    people.each do |person|
      worksheet.append_row(
        [
          person.name,
          person.published_name,
          person.primary_email&.email,
          person.attendance_type,
          person.con_state,
          person.can_stream,
          person.can_stream_exceptions,
          person.can_record,
          person.can_record_exceptions,
          person.sessions.scheduled.collect{|s| "'#{s.title}' - #{s.start_time.strftime('%Y-%m-%d %H:%M %Z')} - #{s.duration} mins - #{s.room.name}" }.join(";\n")
        ]
      )
    end

    send_data workbook.read_string,
              filename: "PeopleRecordStream-#{Time.now.strftime('%m-%d-%Y')}.xlsx",
              disposition: 'attachment'
  end
end
