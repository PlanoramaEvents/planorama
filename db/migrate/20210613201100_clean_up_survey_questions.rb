class CleanUpSurveyQuestions < ActiveRecord::Migration[6.0]
  def change
    remove_column :survey_questions, :tag_context, :string
    remove_column :survey_questions, :answer_type, :string
    remove_column :survey_questions, :mapping, :string

    remove_column :survey_answers, :help, :text
    remove_column :survey_answers, :answertype_id, :integer
    remove_column :survey_answers, :start_time, :text
    remove_column :survey_answers, :start_day, :integer
    remove_column :survey_answers, :duration, :integer
  end
end
