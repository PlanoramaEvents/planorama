class Reports::PeopleReportsController < ApplicationController
  around_action :set_timezone

  def social_media
    authorize Person, policy_class: ReportPolicy

    people = SessionService.live_people

    workbook = FastExcel.open(constant_memory: true)
    worksheet = workbook.add_worksheet("Participant and Social Media")

    worksheet.append_row(
      [
        'Published Name',
        'Attendance Type',
        'Participant Status',
        'Bio',
        'Social Media'
      ]
    )

    people.each do |person|
      social = []
      social << "Twitter: https://twitter.com/#{person.twitter}" unless person.twitter.blank?
      social <<  "Facebook: https://facebook.com/#{person.facebook}" unless person.facebook.blank?
      social <<  "Website: #{person.website}" unless person.website.blank?
      social <<  "Instagram: https://instagram.com/#{person.instagram}" unless person.instagram.blank?
      social <<  "Twitch: https://twitch.tv/#{person.twitch}" unless person.twitch.blank?
      social <<  "Youtube: https://youtube.com/#{person.youtube}" unless person.youtube.blank?
      social <<  "TikTok: https://www.tiktok.com/@#{person.tiktok}" unless person.tiktok.blank?
      social <<  "LinkedIn: https://linkedin.com/in/#{person.linkedin}" unless person.linkedin.blank?
      social <<  "Other Social Media: #{person.othersocialmedia}"  unless person.othersocialmedia.blank?

      worksheet.append_row(
        [
          person.published_name,
          person.attendance_type,
          person.con_state,
          person.bio,
          social.join(",\n")
        ]
      )
    end

    send_data workbook.read_string,
              filename: "ParticipantsSocialMedia-#{Time.now.strftime('%m-%d-%Y')}.xlsx",
              disposition: 'attachment'
  end

  def moderators
    authorize Person, policy_class: ReportPolicy

    people = SessionService.draft_moderators

    workbook = FastExcel.open(constant_memory: true)
    worksheet = workbook.add_worksheet("Moderators and Sessions")

    worksheet.append_row(
      [
        'Published Name',
        'Primary Email',
        'Attendance Type',
        'Participant Status',
        'Session Name',
        'Session Format',
        'Session Environment'
      ]
    )

    people.each do |person|
      person.sessions.moderating.each do |session|
        worksheet.append_row(
          [
            person.published_name,
            person.primary_email&.email,
            person.attendance_type,
            person.con_state,
            session.title,
            session.format&.name,
            session.environment
          ]
        )
      end
    end

    send_data workbook.read_string,
              filename: "ParticipantsModeratingSessions-#{Time.now.strftime('%m-%d-%Y')}.xlsx",
              disposition: 'attachment'
  end

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
