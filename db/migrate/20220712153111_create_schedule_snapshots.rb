class CreateScheduleSnapshots < ActiveRecord::Migration[6.1]
  def change
    create_table :schedule_snapshots, id: :uuid do |t|
      t.string :label
      t.string :created_by
      t.datetime :started_at
      t.datetime :completed_at

      t.integer :lock_version
      t.timestamps
    end

    add_index :schedule_snapshots, :label, unique: true

    reversible do |change|
      change.down do
        remove_column :schedule_snapshots, :status

        execute <<-SQL
          DROP TYPE snapshot_status_enum;
        SQL
      end
      change.up do
        execute <<-SQL
          CREATE TYPE snapshot_status_enum AS ENUM ('not_set', 'in_progress', 'done');
        SQL

        add_column :schedule_snapshots, :status, :snapshot_status_enum, default: 'not_set'
      end
    end
  end
end
