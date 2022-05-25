class CreateConClassRoleAccess < ActiveRecord::Migration[6.1]
  def change
    create_table :convention_role_role_accesses, id: :uuid do |t|
      t.belongs_to :convention_role, type: :uuid
      t.belongs_to :person_role, type: :uuid

      t.integer :lock_version
      t.timestamps
    end
  end
end
