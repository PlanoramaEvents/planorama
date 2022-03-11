desc "Utilities for surveys"

# Import a excel sheet with the survey submissions (from google)
namespace :submission do
  # rake submission:import\['prg_survey.csv','00000000-0000-0000-0000-000000000014'\]
  task :import, [:filename, :survey_id] => :environment do |t, args|
    survey_id = args[:survey_id]

    survey = Survey.find survey_id
    p "Did not find survey with id #{survey_id}" unless survey

    # FastExcel
    xl_file = Roo::Spreadsheet.open(args[:filename])

    # headers, timestamp, username, question text
    xl_file.each_with_pagename do |name, sheet|
      header = question_from_header(sheet.row(1), survey)

      count = -1
      sheet.each do |row|
        count += 1
        next if count == 0
        begin
          create_submission(header, row, survey)
        rescue => msg
          p "****** ERROR row: #{count} - #{msg}"
        end
      end
    end
  end

  def create_submission(header, row, survey)
    Survey::Submission.transaction do
      timestamp = Time.parse row[0]
      email = row[1]
      person = nil

      # get ehe person from their email
      addr = EmailAddress.find_by email: email

      if addr == nil
        raise "Can not find person #{email}"
        # person = Person.create(
        #   name: row[2]
        # )
        # addr = EmailAddress.create(
        #   person: person,
        #   email: email
        # )
      else
        person = addr.person
      end

      submission = Survey::Submission.create!(
                     person: person,
                     survey_id: survey.id,
                     created_at: timestamp,
                     updated_at: timestamp
                   )
      (2..(row.count-1)).each do |n|
        if header[n]
          create_response(question: header[n], submission: submission, value: row[n])
        else
          p "ERROR: no question for column #{n}"
        end
      end
    end
  end

  def question_from_header(cols, survey)
    n = 0
    header = []
    cols.each do |col|
      # check survey from id
      q = Survey::Question.where("REPLACE(question, ' ', '') = ?", col.gsub(/\s+/, "")).first
      header[n] = q
      n += 1
    end

    header
  end

  def create_response(question:, submission:, value: )
    val = case question.question_type
           when :textfield
             value
           when :textbox
             value
           when :singlechoice
             # array, single valued
             fix_answer_uuids question, [value]
           when :multiplechoice
             # array, multiple values - seperated by ;
             fix_answer_uuids question, value.split(";")
           when :dropdown
             fix_answer_uuids question, [value]
           # Address and Socialmedia do not map from google
           # socialmedia: {
           #   twitter: nil, facebook: nil, linkedin: nil, twitch: nil, youtube: nil, instagram: nil, tiktok: nil, other: nil, website: nil
           # }
           # when :socialmedia
           #   empty_json[:socialmedia] = value
           else
             nil
           end

    if val && submission
      # p "create a response for #{value}"
      response = Survey::Response.create_response(
          question: question,
          submission: submission,
          value: val
        )
    end
  end

  # ensure the UUIDs are appended to answers on import
  def fix_answer_uuids(question, values)
    res = []

    values.each do |val|
      answer = question.answers.where("REPLACE(answer, ' ', '') = ?", val.gsub(/\s+/, "")).first
      raise "could not find answer for question #{question.question} => #{val}" unless answer

      res.push "#{answer.id}-#{answer.answer}"
    end

    res
  end
end
