class AddFlagsToSurveys < ActiveRecord::Migration[6.0]
  def change
    add_column :survey_answers, :other, :boolean, default: false
    add_column :survey_questions, :radndomize, :boolean, default: false
  end
end
