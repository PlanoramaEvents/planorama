class AddNextPageToAnswer < ActiveRecord::Migration[6.0]
  def change
    add_column :survey_answers, :next_page_id, :integer
  end
end
