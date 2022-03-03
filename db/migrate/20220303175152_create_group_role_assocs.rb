class CreateGroupRoleAssocs < ActiveRecord::Migration[6.1]
  def change
    create_table :group_role_assocs, id: :uuid do |t|
      t.uuid :person_group_id
      t.uuid :person_role_id

      t.integer :lock_version
      t.timestamps
    end

    add_index :group_role_assocs, [:person_group_id, :person_role_id], unique: true
  end
end
