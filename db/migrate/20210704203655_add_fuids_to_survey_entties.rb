class AddFuidsToSurveyEntties < ActiveRecord::Migration[6.0]
  def change
    # Add fuids to the survey entities
    add_column :surveys, :fuuid, :string
    add_column :survey_pages, :fuuid, :string
    add_column :survey_questions, :fuuid, :string
    add_column :survey_answers, :fuuid, :string
    add_column :survey_submissions, :fuuid, :string
    add_column :survey_responses, :fuuid, :string
  end
end
