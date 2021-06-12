class AddSurveyIdToSurveyQuestion < ActiveRecord::Migration[6.0]
  def change
    add_reference :survey_questions, :survey, index: true
  end
end
