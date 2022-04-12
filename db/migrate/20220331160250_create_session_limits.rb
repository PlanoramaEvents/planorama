class CreateSessionLimits < ActiveRecord::Migration[6.1]
  def change
    create_table :session_limits, id: :uuid do |t|
      t.uuid :person_id
      t.date :day, null: true
      t.integer :max_sessions, null: true

      t.integer :lock_version
      t.timestamps
    end

    add_index :session_limits, :person_id
    add_index :session_limits, [:person_id, :day], unique: true
  end
end
