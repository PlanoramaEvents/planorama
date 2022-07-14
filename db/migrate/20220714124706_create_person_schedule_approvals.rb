class CreatePersonScheduleApprovals < ActiveRecord::Migration[6.1]
  def change
    create_table :person_schedule_approvals do |t|
      # Person
      t.uuid :person_id
      # Schedule workflow
      t.uuid :schedule_workflow_id
      # Approval

      # Comments
      t.text :comments

      t.integer :lock_version
      t.timestamps
    end

    add_index :person_schedule_approvals, [:person_id, :schedule_workflow_id], name: 'psa_person_wrkflw_idx', unique: true

    reversible do |change|
      change.down do
        remove_column :person_schedule_approvals, :approved

        execute <<-SQL
          DROP TYPE schedule_approval_enum;
        SQL
      end
      change.up do
        execute <<-SQL
          CREATE TYPE schedule_approval_enum AS ENUM ('not_set', 'yes', 'no');
        SQL

        add_column :person_schedule_approvals, :approved, :schedule_approval_enum, default: 'not_set'
      end
    end

  end
end
