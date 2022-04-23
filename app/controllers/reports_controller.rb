class ReportsController < ApplicationController

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
