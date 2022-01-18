class RemoveFuuids < ActiveRecord::Migration[6.0]
  def change
    remove_column :surveys, :fuuid, :string
    remove_column :survey_answers, :fuuid, :string
    remove_column :survey_pages, :fuuid, :string
    remove_column :survey_questions, :fuuid, :string
    remove_column :survey_responses, :fuuid, :string
    remove_column :survey_submissions, :fuuid, :string
  end
end
