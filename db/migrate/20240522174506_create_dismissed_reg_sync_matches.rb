class CreateDismissedRegSyncMatches < ActiveRecord::Migration[6.1]
  def change
    create_table :dismissed_reg_sync_matches, id: :uuid do |t|
      t.uuid :person_id, index: true, null: false
      t.string :reg_id, index: true, null: false

      t.integer :lock_version
      t.timestamps
    end

    add_index :dismissed_reg_sync_matches, [:person_id, :reg_id], unique: true, name: "idx_person_reg_id"
  end
end
