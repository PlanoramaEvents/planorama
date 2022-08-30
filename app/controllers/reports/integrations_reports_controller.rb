class Reports::IntegrationsReportsController < ApplicationController

  def airmeet_magic_link
    authorize Person, policy_class: ReportPolicy

    people = AirmeetApiService.virtual_people

    workbook = FastExcel.open(constant_memory: true)
    worksheet = workbook.add_worksheet("Magic Links")

    worksheet.append_row(
      [
        'Published Name',
        'Primary Email',
        'Magic Link'
      ]
    )

    people.each do |person|
      worksheet.append_row(
        [
          person.published_name,
          person.primary_email&.email,
          (person.integrations["airmeet"] || {})["token"] || "See admin notes"
        ]
      )
    end

    send_data workbook.read_string,
              filename: "AirmeetMagicLinks-#{Time.now.strftime('%b-%d-%Y')}.xlsx",
              disposition: 'attachment'
  end

  def airmeet_diffs
    authorize Person, policy_class: ReportPolicy
    AirmeetApiService.clear_room_hosts

    people = AirmeetApiService.virtual_people

    workbook = FastExcel.open(constant_memory: true)
    add_worksheet = workbook.add_worksheet("Added People")
    add_worksheet.append_row(
      [
        'Plano id',
        'Published Name',
        'Email',
        'Thing to paste gail'
      ]
    )

    worksheet = workbook.add_worksheet("Changed People")
    date_time_style = workbook.number_format("d mmm yyyy h:mm")

    worksheet.append_row(
      [
        'Synced At (UTC)',
        'Person Last Updated (UTC)',
        'Airmeet Email',
        'What changed',
        'From what',
        'to what'
      ]
    )

    styles = [date_time_style, date_time_style, nil, nil, nil, nil]

    people.each do |person|
      if !person.registered 
        next
      end
      integrations = person.integrations["airmeet"] || {}
      data = integrations["data"] || {}
      if !integrations["synced"] 
        add_worksheet.append_row(
          [
            person.id,
            person.published_name,
            person.primary_email&.email,
            "AirmeetApiService.person_to_airmeet(Person.find(\"#{person.id}\"))"
          ]
        )
      else
        if data["name"] != person.published_name
          worksheet.append_row(
            [
              integrations["synced"] && DateTime.iso8601(integrations["synced_at"]),
              person.updated_at,
              integrations["speaker_email"],
              "name",
              data["name"],
              person.published_name
            ],
            styles
          )
        end
        if data["email"] != person.primary_email&.email
          worksheet.append_row(
            [
              integrations["synced"] && DateTime.iso8601(integrations["synced_at"]),
              person.updated_at,
              integrations["speaker_email"],
              "email",
              data["email"],
              person.primary_email&.email
            ],
            styles
          )
        end
        bio = ActionView::Base.full_sanitizer.sanitize(person.bio)
        if data["bio"] != bio
          worksheet.append_row(
            [
              integrations["synced"] && DateTime.iso8601(integrations["synced_at"]),
              person.updated_at,
              integrations["speaker_email"],
              "bio",
              data["bio"],
              bio
            ],
            styles
          )
        end
      end
    end

    sessions = AirmeetApiService.virtual_sessions

    add_worksheet = workbook.add_worksheet("Added Sessions")
    add_worksheet.append_row(
      [
        'Plano session id',
        'Session title',
        'Session start time',
        'Session duration',
        'Thing to paste gail'
      ]
    )

    add_styles = [nil, nil, date_time_style, nil, nil]

    worksheet = workbook.add_worksheet("Changed Sessions")
    worksheet.append_row (
      [
        'Synced At (UTC)',
        'Session Last Updated (UTC)',
        'Session title (before)',
        'Session start time (before, UTC)',
        'Field changed',
        'From what',
        'To what'
      ]
    ) 

    styles = [date_time_style, date_time_style, nil, date_time_style, nil, nil, nil]
    
    sessions.each do |session|
      integrations = session.integrations["airmeet"] || {}
      old_data = integrations["data"] || {}
      new_data = AirmeetApiService.serialize_session(session)
      if old_data == new_data
        # nothing has changed, can stop checking
        next
      elsif old_data == {}
        # this is a new session
        add_worksheet.append_row(
          [
            session.id,
            new_data[:sessionTitle],
            new_data[:sessionStartTime],
            new_data[:sessionDuration],
            "AirmeetApiService.session_to_airmeet(PublishedSession.find(\"#{session.id}\"))"
          ],
          add_styles
        )
      else
        p old_data
        p new_data
        old_start_time = DateTime.iso8601(old_data["sessionStartTime"])
        if old_data["sessionTitle"] != new_data[:sessionTitle]
          worksheet.append_row(
            [
              integrations["synced"] && DateTime.iso8601(integrations["synced_at"]),
              session.updated_at,
              old_data["sessionTitle"],
              old_start_time,
              "title",
              old_data["sessionTitle"],
              new_data[:sessionTitle]
            ],
            styles
          )
        end
        if old_data["sessionSummary"] != new_data[:sessionSummary]
          worksheet.append_row(
            [
              integrations["synced"] && DateTime.iso8601(integrations["synced_at"]),
              session.updated_at,
              old_data["sessionTitle"],
              old_start_time,
              "summary",
              old_data["sessionSummary"],
              new_data[:sessionSummary]
            ],
            styles
          )
        end
        if old_start_time != new_data[:sessionStartTime]
          worksheet.append_row(
            [
              integrations["synced"] && DateTime.iso8601(integrations["synced_at"]),
              session.updated_at,
              old_data["sessionTitle"],
              old_start_time,
              "start time",
              old_start_time,
              new_data[:sessionStartTime]
            ],
            [date_time_style, date_time_style, nil, date_time_style, nil, date_time_style, date_time_style]
          )
        end
        if old_data["sessionDuration"] != new_data[:sessionDuration]
          worksheet.append_row(
            [
              integrations["synced"] && DateTime.iso8601(integrations["synced_at"]),
              session.updated_at,
              old_data["sessionTitle"],
              old_start_time,
              "duration",
              old_data["sessionDuration"],
              new_data[:sessionDuration]
            ],
            styles
          )
        end
        if old_data["hostEmail"] != new_data[:hostEmail]
          worksheet.append_row(
            [
              integrations["synced"] && DateTime.iso8601(integrations["synced_at"]),
              session.updated_at,
              old_data["sessionTitle"],
              old_start_time,
              "room (host email)",
              old_data["hostEmail"],
              new_data[:hostEmail]
            ],
            styles
          )
        end
        old_cohost_emails = old_data["cohostEmails"] || []
        new_cohost_emails = new_data[:cohostEmails] || []
        if old_cohost_emails.sort != new_cohost_emails.sort
          worksheet.append_row(
            [
              integrations["synced"] && DateTime.iso8601(integrations["synced_at"]),
              session.updated_at,
              old_data["sessionTitle"],
              old_start_time,
              "moderator (co-host email)",
              old_cohost_emails.join(", "),
              new_cohost_emails.join(", ")
            ],
            styles
          )
        end
        old_speaker_data = old_data["speakerEmails"] || []
        new_speaker_data = new_data[:speakerEmails] || []
        if old_speaker_data.sort != new_speaker_data.sort
          (old_speaker_data | new_speaker_data).each do |sp|
            old_speaker = old_speaker_data.include? sp
            if !old_speaker || !new_speaker_data.include?(sp)
              worksheet.append_row(
                [
                  integrations["synced"] && DateTime.iso8601(integrations["synced_at"]),
                  session.updated_at,
                  old_data["sessionTitle"],
                  old_start_time,
                  old_speaker ? "drop speaker" : "add speaker",
                  old_speaker ? sp : '',
                  old_speaker ? '' : sp
                ],
                styles
              )
            end
          end
        end
      end
    end


    send_data workbook.read_string,
              filename: "AirmeetPersonDiffs-#{Time.now.strftime('%b-%d-%Y-%H.%M')}.xlsx",
              disposition: 'attachment'
  end
end
