desc "Utilities for surveys"

# Import a excel sheet with the survey submissions (from google)
namespace :submission do
  # rake submission:import\['prg_survey.csv'\]
  task :import, [:filename] => :environment do |t, args|
    # FastExcel
    xl_file = Roo::Spreadsheet.open(args[:filename])
    # puts "**** #{xl_file.info}"

    # headers, timestamp, username, question text
    xl_file.each_with_pagename do |name, sheet|
      header = question_from_header(sheet.row(1))

      count = -1
      sheet.each do |row|
        count += 1
        next if count == 0
        create_submission(row)
      end
    end
  end

  def create_submission(row)
    Survey::Submission.transaction do
      timestamp = Time.parse row[0]
      email = row[1]
      # p "ROW: #{email} #{timestamp} #{timestamp.getutc}"
      # get ehe person from their email
      addr = EmailAddress.find_by email: email
      p "*** from email #{addr}"
      (2..(row.count)).each do |n|
        create_response(question: header[n], value: row[n])
      end
    end
  rescue => msg
    p "****** ERROR #{msg}"
  end

  def question_from_header(cols)
    n = 0
    header = []
    cols.each do |col|
      q = Survey::Question.where("REPLACE(question, ' ', '') = ?", col.gsub(/\s+/, "")).first
      header[n] = q
      n += 1
    end

    header
  end

  def create_response(question:, value: )
    p "** #{question.question} => #{value}"
    raise "stop here"
  end
end
