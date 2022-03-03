class CreateActionPermissions < ActiveRecord::Migration[6.1]
  def change
    create_table :action_permissions, id: :uuid do |t|
      t.string  :model_name
      t.string  :action
      t.boolean :allowed, default: false

      t.integer :lock_version
      t.timestamps
    end

    add_index :action_permissions, :model_name
    add_index :action_permissions, [:model_name, :action]
    add_index :action_permissions, [:model_name, :action, :allowed], unique: true
  end
end
