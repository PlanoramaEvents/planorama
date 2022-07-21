class CreateScheduleWorkflows < ActiveRecord::Migration[6.1]
  def change
    create_table :schedule_workflows, id: :uuid do |t|
      # State (none, draft, firm)
      # Who set it
      t.string   :created_by
      # When state is set
      t.datetime :set_at
      # reference to snapshot if applicable
      t.uuid :schedule_snapshot_id, index: { unique: true }

      t.integer :lock_version
      t.timestamps
    end

    reversible do |change|
      change.down do
        remove_column :schedule_workflows, :state

        execute <<-SQL
          DROP TYPE schedule_workflow_enum;
        SQL
      end
      change.up do
        execute <<-SQL
          CREATE TYPE schedule_workflow_enum AS ENUM ('not_set', 'draft', 'firm');
        SQL

        add_column :schedule_workflows, :state, :schedule_workflow_enum, default: 'not_set'
      end
    end
  end
end
