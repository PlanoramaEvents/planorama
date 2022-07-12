class CreatePersonScheduleSnapshots < ActiveRecord::Migration[6.1]
  def change
    create_table :person_schedule_snapshots, id: :uuid do |t|
      t.uuid :person_id
      t.uuid :schedule_snapshot_id
      t.jsonb :snapshot

      t.integer :lock_version
      t.timestamps
    end
  end
end
