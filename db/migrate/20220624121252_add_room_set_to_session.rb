class AddRoomSetToSession < ActiveRecord::Migration[6.1]
  def change
    add_column :sessions, :room_set_id, :uuid, null: true, default: nil
  end
end
