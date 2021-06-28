class FixSurveyFields < ActiveRecord::Migration[6.0]
  def change
    add_column :surveys, :published_on, :datetime
    add_column :surveys, :published_by_id, :integer
    add_column :surveys, :created_by_id, :integer #, null: false
    add_column :surveys, :updated_by_id, :integer
    add_column :surveys, :description, :text

    remove_column :survey_questions, :title, :string
  end
end
