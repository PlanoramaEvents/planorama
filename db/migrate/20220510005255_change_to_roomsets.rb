class ChangeToRoomsets < ActiveRecord::Migration[6.1]
  def change
    rename_table :room_sets, :roomsets
    remove_reference :rooms, :room_set, null: true
    add_reference :rooms, :roomset, null: true, foreign_key: true, type: :uuid
  end
end
