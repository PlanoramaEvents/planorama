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

    people = AirmeetApiService.virtual_people

    workbook = FastExcel.open(constant_memory: true)
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
      integrations = person.integrations["airmeet"] || {}
      data = integrations["data"] || {}
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

    send_data workbook.read_string,
              filename: "AirmeetPersonDiffs-#{Time.now.strftime('%b-%d-%Y-%H.%M')}.xlsx",
              disposition: 'attachment'
  end
end
