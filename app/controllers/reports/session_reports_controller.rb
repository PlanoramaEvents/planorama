class Reports::SessionReportsController < ApplicationController
  around_action :set_timezone

  def participants_over_session_limits
    authorize SessionAssignment, policy_class: Reports::SessionReportPolicy

    workbook = FastExcel.open(constant_memory: true)
    worksheet = workbook.add_worksheet("Participants too Many Sessions")
    people = ::ReportsService.participant_and_session_limits

    worksheet.append_row(
      [
        'Name',
        'Pub Name',
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
        'Pub Name',
        'Session Count',
        'Con Limit'
      ]
    )

    people.each do |person|
      worksheet.append_row(
        [
          person.name,
          person.published_name,
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
    sessions = ::ReportsService.panels_with_too_few_people

    # Session name, Area, session start, participant count, participant count lower bound, list of participants
    worksheet.append_row(
      [
        'Title',
        'Areas',
        'Participant Count',
        'List of Participants'
      ]
    )

    # has_many :submissions
    sessions.each do |session|
      worksheet.append_row(
        [
          session.title,
          session.area_list.sort.join(';'),
          session.nbr_assignments,
          session.session_assignments.collect{|a| a.person.published_name}.join(';')
        ]
      )
    end

    send_data workbook.read_string,
              filename: "PanelsWithTooFewParticipants#{Time.now.strftime('%m-%d-%Y')}.xlsx",
              disposition: 'attachment'
  end

  def panels_with_too_many_people
    authorize SessionAssignment, policy_class: Reports::SessionReportPolicy

    workbook = FastExcel.open(constant_memory: true)
    worksheet = workbook.add_worksheet("Panels with too Many People")
    sessions = ::ReportsService.panels_with_too_many_people

    # Session name, Area, session start, participant count, participant count lower bound, list of participants
    worksheet.append_row(
      [
        'Title',
        'Areas',
        'Participant Count',
        'List of Participants'
      ]
    )

    # has_many :submissions
    sessions.each do |session|
      worksheet.append_row(
        [
          session.title,
          session.area_list.sort.join(';'),
          session.nbr_assignments,
          session.session_assignments.collect{|a| a.person.published_name}.join(';')
        ]
      )
    end

    send_data workbook.read_string,
              filename: "PanelsWithTooManyParticipants#{Time.now.strftime('%m-%d-%Y')}.xlsx",
              disposition: 'attachment'
  end

  def set_timezone(&block)
    timezone = ConfigService.value('convention_timezone')
    Time.use_zone(timezone, &block)
  end
end
