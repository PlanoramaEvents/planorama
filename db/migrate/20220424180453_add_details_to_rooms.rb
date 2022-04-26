class AddDetailsToRooms < ActiveRecord::Migration[6.1]
  def change
    add_column :rooms, :room_floor, :string
    add_column :rooms, :open_for_schedule, :boolean, default: true
    add_column :rooms, :is_virtual, :boolean, default: false
    add_column :rooms, :dimensions, :text
    add_column :rooms, :area_of_space, :decimal
  end
end
