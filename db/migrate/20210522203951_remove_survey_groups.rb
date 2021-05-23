class RemoveSurveyGroups < ActiveRecord::Migration[6.0]
  def change
    drop_table :survey_groups
    remove_column :survey_questions, :survey_group_id, :integer
  end
end
