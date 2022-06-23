class CreateRoomServicesToSessions < ActiveRecord::Migration[6.1]
  def change
    create_table :room_services_sessions, id: false do |t|
      t.uuid :room_service_id
      t.uuid :session_id
    end
    add_index :room_services_sessions, :room_service_id
    add_index :room_services_sessions, :session_id
    add_index :room_services_sessions, [:room_service_id, :session_id], unique: true
  end
end
