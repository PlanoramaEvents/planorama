class CreateInterestRoleEnum < ActiveRecord::Migration[6.0]
  def up
    execute <<-SQL
      CREATE TYPE interest_role_enum AS ENUM ('no_preference', 'can_moderate', 'not_moderate');
    SQL
    add_column :session_assignments, :interest_role, :interest_role_enum, default: 'no_preference'
    add_index :session_assignments, :interest_role

    remove_column :session_assignments, :interest_role_type, :uuid
  end

  def down
    remove_column :session_assignments, :interest_role
    execute <<-SQL
      DROP TYPE interest_role_enum;
    SQL

    add_column :session_assignments, :interest_role_type, :uuid, null: true, default: nil
  end
end
