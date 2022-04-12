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
          p "****** ERROR row: #{count+1} - #{msg}"
        end
      end
    end
  end

  def create_submission(header, row, survey)
    Survey::Submission.transaction do
      timestamp = Time.parse row[0]
      email = row[1]
      person = nil

      # get the person from their email
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

      # Check if submission exists, if so do not import again
      submission = Survey::Submission.where(
                     person_id: person.id,
                     survey_id: survey.id,
                   )
      return if submission.count > 0

      # Ok to change the person's name as long as the email is the same
      submission = Survey::Submission.create!(
                     person: person,
                     survey_id: survey.id,
                     created_at: timestamp,
                     updated_at: timestamp
                   )

      # change the state of the person to applied on import
      # Also need better error reporting for which questions are a problem etc.
      (2..(row.count-1)).each do |n|
        if header[n]
          create_response(question: header[n], submission: submission, value: row[n])
        else
          p "person (#{email}) - ERROR: no question for column #{n}"
        end
      end

      person.con_state = Person.con_states[:applied] unless person.con_state
      person.save!
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
             if value
               fix_answer_uuids question, value.split(";")
             end
           when :dropdown
             fix_answer_uuids question, [value]
           when :email
             [value]
           when :boolean
             [value.downcase == 'yes']
           when :yesnomaybe
             # Need special consideration for the elaborate section of the question
             # there are 2 questions from google that this should deal with
             if value
               val = if value.include? 'except for items'
                       'maybe'
                     elsif value.downcase == 'yes'
                       'yes'
                     elsif value.downcase == 'no'
                       'no'
                     end
               if val
                 {
                   text: '',
                   value: [val.downcase]
                 }
               end
             end
           when :attendance_type
             if value.include?('**In-person and virtual:**')
               ['hybrid']
             elsif value.include?('**In-person only:**')
               ['in person']
             elsif value.include?('**Virtual only:**')
               ['virtual']
             end
           else
             nil
           end

    if val && submission
      response = Survey::Response.create_response(
          question: question,
          submission: submission,
          value: val
        )
      if question.id == '00000000-0000-0000-0000-000000000052'
        fix_yesnomaybe(question_id: '00000000-0000-0000-0000-000000000051', submission_id: submission.id, val: val)
      end
      if question.id == '00000000-0000-0000-0000-000000000055'
        fix_yesnomaybe(question_id: '00000000-0000-0000-0000-000000000054', submission_id: submission.id, val: val)
      end
    end
  end

  def fix_yesnomaybe(question_id: , submission_id:, val:)
    existing_response = Survey::Response.find_or_create_by(question_id: question_id, submission_id: submission_id)
    if existing_response
      new_val = existing_response.response || Survey::Response.empty_json
      new_val[:text] = val
      existing_response.response = new_val
      existing_response.save!
    else
      response = Survey::Response.create_response(
          question_id: question_id,
          submission: submission,
          value: val
        )
    end
  end

  # ensure the UUIDs are appended to answers on import
  def fix_answer_uuids(question, values)
    res = []

    values.each do |val|
      if val == 'I am interested in receiving information about presenting on our Academic program (You can find out more about our Academic program here <<link to Academic blurb that will be on Chicon website>>).'
        res.push "00000000-0000-0000-0000-000000000142-I am interested in receiving information about presenting on our Academic program (You can find out more about our Academic program at https://chicon.org/academic-program/ )."
      else
        answer = question.answers.where("REPLACE(answer, ' ', '') = ?", val.gsub(/\s+/, "")).first
        raise "could not find answer for question #{question.question} => #{val}" unless answer

        res.push "#{answer.id}-#{answer.answer}"
      end
    end

    res
  end
end
