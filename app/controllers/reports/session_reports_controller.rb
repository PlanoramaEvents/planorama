class Reports::SessionReportsController < ApplicationController

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
              filename: "Panels_With_Too_Few_People_#{Time.now.strftime('%m-%d-%Y')}.xlsx",
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
              filename: "Panels_With_Too_Many_People_#{Time.now.strftime('%m-%d-%Y')}.xlsx",
              disposition: 'attachment'
  end
end
