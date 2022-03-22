class CreatePersonRoleAssocs < ActiveRecord::Migration[6.1]
  def change
    create_table :person_role_assocs, id: :uuid do |t|
      t.uuid :person_id
      t.uuid :person_role_id

      t.integer :lock_version
      t.timestamps
    end

    add_index :person_role_assocs, [:person_id, :person_role_id], unique: true
  end
end
