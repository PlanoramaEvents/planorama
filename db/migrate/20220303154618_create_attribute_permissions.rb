class CreateAttributePermissions < ActiveRecord::Migration[6.1]
  def change
    reversible do |change|
      change.up do
        execute <<-SQL
          CREATE TYPE action_enum AS ENUM ('none', 'read', 'write');
        SQL
      end
      change.down do

        execute <<-SQL
          DROP TYPE action_enum;
        SQL
      end
    end

    # Model, attribure, CRUD
    create_table :attribute_permissions, id: :uuid do |t|
      t.string  :model_name
      t.string  :attribute_name
      t.boolean :allowed, default: false

      t.integer :lock_version
      t.timestamps
    end
    add_column :attribute_permissions, :action, :action_enum, default: 'none'

    add_index :attribute_permissions, [:model_name, :attribute_name, :action], name: 'attr_model_idx'
    add_index :attribute_permissions, [:model_name, :attribute_name, :action, :allowed], unique: true, name: 'attr_model_allowed_idx'
  end
end
