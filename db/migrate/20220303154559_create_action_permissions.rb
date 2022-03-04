class CreateActionPermissions < ActiveRecord::Migration[6.1]
  def change
    reversible do |change|
      change.up do
        execute <<-SQL
          CREATE TYPE action_scope_enum AS ENUM ('none', 'owner', 'role');
        SQL
      end
      change.down do

        execute <<-SQL
          DROP TYPE action_scope_enum;
        SQL
      end
    end


    create_table :action_permissions, id: :uuid do |t|
      t.string  :model_name
      t.string  :action
      t.boolean :allowed, default: false
      t.uuid    :person_role_id

      t.integer :lock_version
      t.timestamps
    end
    add_column :action_permissions, :action_scope, :action_scope_enum, default: 'none'

    add_index :action_permissions, :model_name
    add_index :action_permissions, [:model_name, :action, :action_scope], name: 'act_perm_mdl_scope_idx'
    add_index :action_permissions, [:model_name, :action, :action_scope, :allowed], name: 'act_perm_mdl_allowed_scope_idx', unique: true
  end
end
