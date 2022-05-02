class PersonRoleToAppRole < ActiveRecord::Migration[6.1]
  def change
    reversible do |dir|
      dir.up do
        if ActiveRecord::Migration.connection.index_exists? :person_role_assocs, [:person_id, :person_role_id], name: 'index_person_role_assocs_on_person_id_and_person_role_id'
          remove_index :person_role_assocs, name: 'index_person_role_assocs_on_person_id_and_person_role_id'
        end

        if ActiveRecord::Migration.connection.index_exists? :person_role_assocs, [:person_role_id], name: 'index_convention_role_role_accesses_on_person_role_id'
          remove_index :convention_role_role_accesses, name: 'index_convention_role_role_accesses_on_person_role_id'
        end
      end
    end

    rename_table :person_roles, :application_roles
    rename_table :person_role_assocs, :application_role_assocs

    rename_column :application_role_assocs, :person_role_id, :application_role_id
    add_index :application_role_assocs, %i(application_role_id), name: 'application_role_assocs_app_role_idx'

    rename_column :convention_role_role_accesses, :person_role_id, :application_role_id
    add_index :convention_role_role_accesses, %i(application_role_id), name: 'convention_role_role_accesses_app_role_idx'

    add_column :application_roles, :sensitive_access, :boolean, default: false
  end
end
