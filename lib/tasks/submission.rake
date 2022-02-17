desc "Utilities for surveys"

# Import a excel sheet with the survey submissions (from google)
namespace :submission do
  task :import, [:filename] => :environment do |t, args|

    # FastExcel
    xl_file = Roo::Spreadsheet.open(args[:filename])

    puts "**** #{xl_file.info}"

    # headers, timestamp, username, question text

    xl_file.each_with_pagename do |name, sheet|
      # p sheet.row(1)
      cols = sheet.row(1)
      cols.each do |col|
        q = Survey::Question.where("REPLACE(question, ' ', '') = ?", col.gsub(/\s+/, "")).first
        # find_by question: col
        p "#{col} => #{q}" if q.nil?
        # p "#{q.id }#{col} => #{q}" if q
      end
      # sheet.each do |row|
      #   p "ROW: #{row}"
      # end
    end
    # xl_file.each_row_streaming(pad_cells: true) do |row|
    #   puts "ROW #{row}"
    # end
  end
end

# Do you represent something other than a solely US-centric perspective?  If yes, please elaborate.
# Do you represent something other than a solely US-centric perspective? If yes, please elaborate.
# Topics you do not want to be streamed while talking about are (this can be updated later):
# Topics you do not want to be streamed while talking about are (this can be updated later):
#
# Topics you do not want to be streamed while talking about are (this can be updated later):
# Topics you do not want to be streamed while talking about are (this can be updated later):

# Generic import
# def import_from_excel(filename:, organization: nil, offset: 1, alt_lang: nil)
#   columns = get_column_layout(organization: organization)
#
#   Session.transaction do
#     support_user = Person.find 0
#     xl_file = Roo::Spreadsheet.open(filename)
#
#     xl_file.each_row_streaming(pad_cells: true, offset: offset) do |row|
#       # visibility_code = 'ORG'
#       visibility_code = 'PUB'
#
#       external_id = row[columns[:external_id]].to_s
#       next unless external_id.present?
#       print('+')
#
#       title = row[columns[:title]].to_s
#       next unless title.present?
#
#       print('.')
#
#       # Create the session and it's details
#       session = Session.find_by external_id: external_id
#       session ||= Session.new
#
#       details = session.create_draft_detail
#       details.title = title
#       details.description = row[columns[:description]].to_s if row[columns[:description]]
#       details.created_by_person_id = support_user.id
#       details.updated_by_person_id = support_user.id
#       details.visibility_code = visibility_code
#
#       # we have to have a value in here so pick one if not provided
#       details.minimum_planned_participants = 0
#       details.maximum_planned_participants = 5
#
#       details.duration = 60
#       if columns[:start_time] && row[columns[:start_time]] && (row[columns[:start_time]].class == Roo::Excelx::Cell::DateTime)
#         print("\n#{row[columns[:start_time]].class}\n")
#         print('T')
#         details.start_date_time = Time.zone.local_to_utc row[columns[:start_time]].value
#         if row[columns[:end_time]] && (row[columns[:end_time]].class == Roo::Excelx::Cell::DateTime)
#           details.end_date_time = Time.zone.local_to_utc row[columns[:end_time]].value
#           details.duration = (details.end_date_time - details.start_date_time).to_i / 60
#         end
#       end
#
#       if columns[:visibility_from] && row[columns[:visibility_from]] && (row[columns[:visibility_from]].class == Roo::Excelx::Cell::DateTime)
#         print("\nV: #{row[columns[:visibility_from]].class}\n")
#         details.visiblity_from_date_time = Time.zone.local_to_utc row[columns[:visibility_from]].value
#       end
#       if columns[:visibility_to] && row[columns[:visibility_to]] && (row[columns[:visibility_to]].class == Roo::Excelx::Cell::DateTime)
#         details.visiblity_until_date_time = Time.zone.local_to_utc row[columns[:visibility_to]].value
#       end
#
#       details.format = find_or_create_format(row[columns[:format]].to_s.gsub(/\A[[:space:]]+|[[:space:]]+\z/, '')) if columns[:format] && row[columns[:format]]
#
#       if alt_lang
#         I18n.with_locale(alt_lang) do
#           title = row[columns[:alt_title]].to_s
#           details.title = title
#           details.description = row[columns[:alt_description]].to_s if row[columns[:alt_description]]
#         end
#       end
#
#       details.save!
#
#       if columns[:track] && row[columns[:track]]
#         category = find_or_create_category(row[columns[:track]].to_s.gsub(/\A[[:space:]]+|[[:space:]]+\z/, ''))
#         session.category_ids = [category.id] if category
#       end
#
#       # create the sesiion info
#       session.draft_detail = details
#       session.external_id = external_id
#       session.next_action = ::Session.next_actions[:publish_next]
#       session.next_action_req_date_time = Time.now
#       session.next_action_req_by_person_id = support_user.id
#       session.save!
#
#       first_name = row[columns[:first_name]]
#       last_name = row[columns[:last_name]]
#       email = row[columns[:email]]
#       if first_name && last_name
#         person = find_or_create_person(
#           first_name: first_name.to_s.gsub(/\A[[:space:]]+|[[:space:]]+\z/, ''),
#           last_name: last_name.to_s.gsub(/\A[[:space:]]+|[[:space:]]+\z/, ''),
#           email: email.to_s.gsub(/\A[[:space:]]+|[[:space:]]+\z/, '')
#         )
#         role = ScheduleEntryRole.find_by internal_name: 'Speaker'
#
#         # check sched
#         if session.participants.where(person_id: person.id).size == 0
#           ::Dirac::ScheduleEntryService.create_schedule_entry(
#             owner: person,
#             entity: session,
#             role: role,
#             visibility_code: role.default_visibility_code,
#             editability_code: ScheduleEntry.editability_codes[:organizer_can_edit],
#             created_by_type: ScheduleEntry.created_by_types[:SYSTEM],
#             created_because: 'Import from File',
#             check_business_validator: false,
#             session_to_check: SessionToUse::LATEST,
#             publish: false,
#             options: {
#               next_action: ScheduleEntry.next_actions[:publish_next]
#             }
#           )
#         end
#       end
#
#       # break
#     end
#   end
# end
