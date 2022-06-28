class CreateIgnoredConflicts < ActiveRecord::Migration[6.1]
  def change
    create_table :ignored_conflicts, id: :uuid do |t|
      t.string :conflict_id, limit: 2048
      t.string :conflict_type

      t.timestamps
    end

    add_index :ignored_conflicts, [:conflict_id, :conflict_type], unique: true
  end
end
