class CreateAppRoleRelationships < ActiveRecord::Migration[6.1]
  def change
    reversible do |dir|
      dir.up do
        if ActiveRecord::Base.connection.data_source_exists? 'convention_role_role_accesses'
          drop_table :convention_role_role_accesses
        end
      end
    end

    create_table :people_application_roles, id: false do |t|
      t.uuid :application_role_id
      t.uuid :person_id
    end
    add_index :people_application_roles, :application_role_id
    add_index :people_application_roles, :person_id
    add_index :people_application_roles, [:application_role_id, :person_id], unique: true, name: 'par_approle_person_idx'

    create_table :convention_roles_application_roles, id: false do |t|
      t.uuid :application_role_id
      t.uuid :convention_role_id
    end
    add_index :convention_roles_application_roles, :application_role_id
    add_index :convention_roles_application_roles, :convention_role_id
    add_index :convention_roles_application_roles, [:application_role_id, :convention_role_id], unique: true, name: 'car_approle_person_idx'
  end
end
