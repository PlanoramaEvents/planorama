class AdjustResponses < ActiveRecord::Migration[6.0]
  def change
    remove_column :survey_responses, :person_id, :integer
    remove_column :survey_responses, :survey_id, :integer
    #
    add_reference :survey_responses, :survey_submission, index: true, null: false, foreign_key: true
  end
end
