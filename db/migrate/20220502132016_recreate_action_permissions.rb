class RecreateActionPermissions < ActiveRecord::Migration[6.1]
  def change
    reversible do |dir|
      dir.up do
        drop_table :action_permissions
      end
    end

    create_table :model_permissions, primary_key: [:model_name, :application_role_id] do |t|
      t.string :model_name
      t.belongs_to :application_role, type: :uuid

      t.jsonb :actions

      t.integer :lock_version
      t.timestamps
    end
  end
end
