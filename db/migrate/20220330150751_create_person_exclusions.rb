class CreatePersonExclusions < ActiveRecord::Migration[6.1]
  def change
    create_table :person_exclusions, id: :uuid do |t|
      t.uuid :person_id
      t.uuid :exclusion_id

      t.integer :lock_version
      t.timestamps
    end

    add_index :person_exclusions, :person_id
    add_index :person_exclusions, [:person_id, :exclusion_id], unique: true
  end
end
