class AdjustPersonRoles < ActiveRecord::Migration[6.1]
  def change
    reversible do |change|
      change.down do
        remove_column :action_permissions, :action_scope

        execute <<-SQL
          CREATE TYPE action_scope_enum AS ENUM ('none', 'owner', 'role');
        SQL

        add_column :action_permissions, :action_scope, :action_scope_enum, default: 'none'
      end
      change.up do
        remove_column :action_permissions, :action_scope

        execute <<-SQL
          DROP TYPE action_scope_enum;
        SQL

        add_column :action_permissions, :action_scope, :string, default: nil
      end
    end

    remove_column :person_roles, :role, :person_role
    remove_column :person_roles, :person_id, :uuid

    add_column :person_roles, :can_access_sensitive_data, :boolean, default: false
  end
end
