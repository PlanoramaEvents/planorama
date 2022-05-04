class AdjustRoleRelationship < ActiveRecord::Migration[6.1]
  def change
    reversible do |dir|
      dir.up do
        if ActiveRecord::Base.connection.data_source_exists? 'application_roles_convention_roles'
          drop_table :application_roles_convention_roles
        end
      end
    end

    # I can have an array of con_roles ...
    remove_column :application_roles, :can_access_sensitive_data, :boolean
    add_column :application_roles, :con_roles, :text, array: true, default: []
    add_index :application_roles, :con_roles, using: 'gin'
  end
end
