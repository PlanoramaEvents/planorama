class AddLinkedFieldToQuestion < ActiveRecord::Migration[6.1]
  def change
    add_column :survey_questions, :linked_field, :text, default: nil
  end
end
