class AddUniqueSubmissionToSurvey < ActiveRecord::Migration[6.1]
  def change
    add_column :surveys, :unique_submission, :boolean, default: true
  end
end
