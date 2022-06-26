class CreateExclusionToSessions < ActiveRecord::Migration[6.1]
  def change
    create_table :exclusions_sessions, id: false do |t|
      t.uuid :exclusion_id
      t.uuid :session_id
    end
    add_index :exclusions_sessions, :exclusion_id
    add_index :exclusions_sessions, :session_id
    add_index :exclusions_sessions, [:exclusion_id, :session_id], unique: true
  end
end
