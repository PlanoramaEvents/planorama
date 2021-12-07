class AddMailTemplateStates < ActiveRecord::Migration[6.0]
  def up
    execute <<-SQL
      CREATE TYPE mailing_state_enum AS ENUM ('draft', 'submitted', 'sent');
    SQL
    add_column :mailings, :mailing_state, :mailing_state_enum, default: 'draft'
    add_index :mailings, :mailing_state
  end

  def down
    remove_column :mailings, :mailing_state
    execute <<-SQL
      DROP TYPE mailing_state_enum;
    SQL
  end
end
