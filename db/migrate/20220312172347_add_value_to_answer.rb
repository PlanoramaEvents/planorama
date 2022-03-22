class AddValueToAnswer < ActiveRecord::Migration[6.1]
  def change
    add_column :survey_answers, :value, :string, default: nil
  end
end
