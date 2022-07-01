class AddRoomNotesToSession < ActiveRecord::Migration[6.1]
  def change
    add_column :sessions, :room_notes, :text
  end
end
