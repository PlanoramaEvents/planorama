class ChangeSurveyColumns < ActiveRecord::Migration[6.0]
  def change
    rename_column :survey_questions, :survey_page_id, :page_id
    rename_column :survey_responses, :survey_question_id, :question_id
    rename_column :survey_responses, :survey_submission_id, :submission_id
    rename_column :survey_answers, :survey_question_id, :question_id
  end
end
