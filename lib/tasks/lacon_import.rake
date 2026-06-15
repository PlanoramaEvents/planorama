desc "Utilities for importing sessions etc for LAcon"

require 'csv'

strip_converter = proc {|field| field ? field.strip : field}
CSV::Converters[:strip] = strip_converter

namespace :lacon_import do
  task :import_sessions, [:filename] => :environment do |t, args|
    if !args[:filename]
      p "You need to add the filename as an argument: rake lacon_import:filename[/path/to/file]"
    end

    # TODO
    File.open(args[:filename]) do |file|
      parsed_output = CSV.read(file, headers: true, header_converters: :symbol, converters: :strip)

      errored_rows = []
      duplicate_session = 0
      count = 0
      parsed_output.each do |row|
        if count == 0
          count += 1
          next
        end

        areas = row[0].split(",")
        title = row[1]
        description = row[2] ? row[2].strip : ""
        goh_notes = row[4]
        interest_open = row[5]
        interest_instructions = row[6] ? row[6].strip : ""
        notes = row[7] ? row[7].strip : ""
        # sess env 8
        # Duration 9
        # signup 10
        # max openings 11
        # participant 12
        if title && (title.length > 0)
          # if Session.find_by title: title.strip
          #   errored_rows << count
          #   duplicate_session += 1
          #   next
          # end

          format = Format.find_or_create_by(name: row[3].strip)
          environment = 'unknown'
          environment = 'in_person' if row[8] == 'In Person'
          environment = 'virtual' if row[8] == 'Online'
          duration = 60
          duration = row[9].strip.blank? ? 60 : row[8].strip.to_i if row[9]
          require_signup = false
          require_signup = row[10].strip == 'Yes' if row[10]
          audience_size = nil
          audience_size = row[11].strip.blank? ? nil : row[11].to_i if row[11]
          email = nil
          person = nil
          email = EmailAddress.where(email: row[12].strip, isdefault: true).first if row[12]
          person = email.person if email

          Session.transaction do
            # p "#{title} #{description} #{interest_open} #{interest_instructions} #{[notes, goh_notes].join("\n").strip} #{format} #{duration} #{row[8]} == #{environment} #{require_signup} #{audience_size}"
            session = Session.create!(
              title: title.strip,
              description: description.strip,
              open_for_interest: interest_open && interest_open == 'Yes',
              instructions_for_interest: interest_instructions.strip,
              item_notes: [notes, goh_notes].join("\n").strip,
              format: format,
              duration: duration,
              environment: environment,
              require_signup: require_signup,
              audience_size: audience_size
            )

            primary = true
            areas.each do |area_name|
              area = Area.find_or_create_by(name: area_name.strip)
              SessionArea.create!(
                session: session,
                area: area,
                primary: primary
              )
              primary = false
            end

            if person
              role = SessionAssignmentRoleType.find_by(name: 'Participant')
              SessionAssignment.create!(
                session: session,
                person: person,
                visibility: 'public',
                session_assignment_role_type: role
              )
            end
          end

        end


        count += 1
      end

      p "Imported #{count} sessions with errors #{errored_rows}"
    end
  end
end