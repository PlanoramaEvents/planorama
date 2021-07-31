class AddBranchingToQuestion < ActiveRecord::Migration[6.0]
  def change
    add_column :survey_questions, :branching, :boolean, default: false
  end
end
