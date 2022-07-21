class RemoveSnapshotConstraint < ActiveRecord::Migration[6.1]
  def change
    change_column_null :schedule_workflows, :schedule_snapshot_id, true
  end
end
