class AddQuestionSoftDelete < ActiveRecord::Migration[6.1]
  def change
    add_column :survey_questions, :deleted_at, :datetime, default: nil
  end
end
