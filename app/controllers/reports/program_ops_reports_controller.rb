class Reports::ProgramOpsReportsController < ApplicationController
  around_action :set_timezone

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
      row = [
        person.published_name
      ]
      styles = [nil]

      grouped.each do |assignment|
        row.concat [
          assignment.session.title,
          assignment.session.start_time ? FastExcel.date_num(assignment.session.start_time, assignment.session.start_time.in_time_zone.utc_offset) : nil,
          assignment.session.duration + ' mins',
          assignment.session.room&.name,
        ]
        styles.concat [
          nil, date_time_style, nil, nil
        ]
      end
      max_sessions = grouped.size if grouped.size > max_sessions

      worksheet.append_row(row, styles)
    end

    header = ['Published Name']
    (0..max_sessions).each do |n|
      header.concat ["Title #{n+1}", "Start Time #{n+1}", "Duration #{n+1}", "Room #{n+1}"]
    end
    worksheet.write_row(0, header)

    send_data workbook.read_string,
              filename: "BackOfBadge-#{Time.now.strftime('%m-%d-%Y')}.xlsx",
              disposition: 'attachment'
  end
end
