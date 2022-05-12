class UpdateRoomsFields < ActiveRecord::Migration[6.1]
  def up
    remove_column :rooms, :dimensions
    rename_column :rooms, :room_floor, :floor
    add_column :rooms, :length, :decimal
    add_column :rooms, :width, :decimal
    add_column :rooms, :height, :decimal
  end
  def down
    add_column :rooms, :dimensions, :text
    rename_column :rooms, :floor, :room_floor
    remove_column :rooms, :length
    remove_column :rooms, :width
    remove_column :rooms, :height
  end
end
