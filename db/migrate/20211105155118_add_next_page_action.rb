class AddNextPageAction < ActiveRecord::Migration[6.0]
  def up
    execute <<-SQL
      CREATE TYPE next_page_action_enum AS ENUM ('none', 'next_page', 'submit');
    SQL
    add_column :survey_pages, :next_page_action, :next_page_action_enum, default: 'none'
    add_index :survey_pages, :next_page_action

    add_column :survey_answers, :next_page_action, :next_page_action_enum, default: 'none'
    add_index :survey_answers, :next_page_action
  end

  def down
    remove_column :survey_pages, :next_page_action
    remove_column :survey_answers, :next_page_action
    execute <<-SQL
      DROP TYPE next_page_action_enum;
    SQL
  end
end
