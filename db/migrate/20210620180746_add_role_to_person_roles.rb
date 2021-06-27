class AddRoleToPersonRoles < ActiveRecord::Migration[6.0]
  def up
    execute <<-SQL
      CREATE TYPE person_role AS ENUM ('admin', 'planner', 'member');
    SQL
    add_column :person_roles, :role, :person_role
    add_index :person_roles, :role
  end

  def down
    remove_column :person_roles, :role
    execute <<-SQL
      DROP TYPE person_role;
    SQL
  end
end
