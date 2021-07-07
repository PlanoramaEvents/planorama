class AdjustSurveys < ActiveRecord::Migration[6.0]
  def change
    add_column :surveys, :mandatory_star, :boolean, default: true
    add_column :surveys, :numbered_questions, :boolean, default: false
    add_column :surveys, :branded, :boolean, default: true
    add_column :surveys, :allow_submission_edits, :boolean, default: true

    remove_column :surveys, :authenticate, :boolean
    remove_column :surveys, :alias, :string
    remove_column :surveys, :header_image, :string
  end
end
