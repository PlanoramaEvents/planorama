class AddRoomSetToRooms < ActiveRecord::Migration[6.1]
  def change
    add_reference :rooms, :room_set, null: false, foreign_key: true
  end
end
