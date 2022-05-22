class ReportsController < ApplicationController

  # Sessions that are assigned - this should only return if at least one of the three below assigned status have anyone assigned to it
  #
  #     Area(s)
  #     Title
  #     Moderator(s) - The names of people assigned as moderator
  #     Participants - The names of people assigned as participants
  #     Reserve - The names of people selected as reserved
  #
  def sessions_with_participants
    authorize SessionAssignment, policy_class: ReportsPolicy

    session_table = Arel::Table.new(Session.table_name)
    subquery = Session.area_list.as('areas_list')
    joins = [
      session_table.create_join(
        subquery,
        session_table.create_on(
          subquery[:session_id].eq(session_table[:id])
        ),
        Arel::Nodes::OuterJoin
      )
    ]

    # array aggregate ...
    sessions = Session.select(
                  ::Session.arel_table[Arel.star],
                  'areas_list.area_list'
                )
                .joins(joins)
                .eager_load(:areas, {session_assignments: [:person]})
                .where("session_assignments.session_assignment_role_type_id is not null")
                .order('sessions.title')

    workbook = FastExcel.open(constant_memory: true)
    worksheet = workbook.add_worksheet("Session With Participants")

    worksheet.append_row(
      [
        'Title',
        'Areas',
        'Moderators',
        'Participants',
        'Reserves'
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
          session.session_assignments.select{|a| a.session_assignment_role_type_id == moderator.id}.collect{|a| a.person.name}.join(';'),
          session.session_assignments.select{|a| a.session_assignment_role_type_id == participant.id}.collect{|a| a.person.name}.join(';'),
          session.session_assignments.select{|a| a.session_assignment_role_type_id == reserve.id}.collect{|a| a.person.name}.join(';'),
        ]
      )
    end

    send_data workbook.read_string,
              filename: "SessionsWithPartiipants#{Time.now.strftime('%m-%d-%Y')}.xlsx",
              disposition: 'attachment'

  end

  # Assigned session by participant - this should only return if the person is assigned as a moderator or a participant
  #
  #     Name
  #     Item title
  #     If they are assigned as a moderator or not for that item
  def assigned_sessions_by_participant
    authorize SessionAssignment, policy_class: ReportsPolicy

    people = Person.includes(
      {session_assignments: [:session, :session_assignment_role_type]}
    ).references(
      {session_assignments: :session}
    ).where(
      "session_assignments.session_assignment_role_type_id is not null"
    ).order("people.name")

    workbook = FastExcel.open(constant_memory: true)
    worksheet = workbook.add_worksheet("Assigned Sessions")

    worksheet.append_row(
      [
        'Name',
        'Pub Name',
        'Session Title',
        'Role'
      ]
    )

    people.each do |person|
      person.session_assignments.each do |assignment|
        worksheet.append_row(
          [
            person.name,
            person.published_name,
            assignment.session.title,
            assignment.session_assignment_role_type.name
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
    # TZ
    timezone = ConfigService.value('convention_timezone')
    # We want the times to be in the TZ of the con for the report
    Time.use_zone(timezone) do
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
      )

      workbook = FastExcel.open(constant_memory: true)
      worksheet = workbook.add_worksheet("Participant Availabilities")

      worksheet.append_row(
        [
          'Name',
          'Pub Name',
          'Attendance Type',
          'Availabilities',
          'Limits',
          'Exclusions',
          'Availabilty Notes'
        ]
      )

      people.each do |person|
        worksheet.append_row(
          [
            person.name,
            person.published_name,
            person.attendance_type,
            person.availabilities.order('start_time').collect{|av| "#{av.start_time} to #{av.end_time}" }.join(";\n"),
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
  end

  # By participant
  # Name
  # What they signed up for
  # How they ranked it
  # What they wrote in the free text box
  # (Nice to have) Area
  def participant_selections
    authorize SessionAssignment, policy_class: ReportsPolicy

    assignments = SessionAssignment
                    .joins(:person)
                    .includes([{session: :areas}, :person])
                    .where(interested: true).order("people.name")

    workbook = FastExcel.open(constant_memory: true)
    worksheet = workbook.add_worksheet("Participant Selections")

    worksheet.append_row(
      [
        'Name',
        'Pub Name',
        'Title',
        'Ranking',
        'Notes',
        'Areas'
      ]
    )
    assignments.each do |assignment|
      worksheet.append_row(
        [
          assignment.person.name,
          assignment.person.published_name,
          assignment.session.title,
          assignment.interest_ranking,
          assignment.interest_notes,
          assignment.session.areas.collect(&:name).join("; ")
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
    authorize Session, policy_class: ReportsPolicy

    sessions = Session
                .eager_load(:areas, {session_assignments: [:person]})
                .where('session_assignments.interested': true)
                .order('sessions.title')

    workbook = FastExcel.open(constant_memory: true)
    worksheet = workbook.add_worksheet("Session Selections")

    worksheet.append_row(
      [
        'Title',
        'Who is Interested',
        'Who is Interested (Pub Name)',
        'Ranking',
        'Notes',
        'Areas'
      ]
    )

    sessions.each do |session|
      session.session_assignments.each do |assignment|
        worksheet.append_row(
          [
            session.title,
            assignment.person.name,
            assignment.person.published_name,
            assignment.interest_ranking,
            assignment.interest_notes,
            session.areas.collect(&:name).join("; ")
          ]
        )
      end
    end

    send_data workbook.read_string,
              filename: "SessionSelections_#{Time.now.strftime('%m-%d-%Y')}.xlsx",
              disposition: 'attachment'
  end
end
