class CreateSessionRooms < ActiveRecord::Migration[6.1]
  def change
    create_table :rooms_sessions, id: false do |t|
      t.uuid :room_id
      t.uuid :session_id
    end
    add_index :rooms_sessions, :room_id
    add_index :rooms_sessions, :session_id
    add_index :rooms_sessions, [:room_id, :session_id], unique: true
  end
end
