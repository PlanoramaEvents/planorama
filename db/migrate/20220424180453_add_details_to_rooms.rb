class AddDetailsToRooms < ActiveRecord::Migration[6.1]
  def change
    add_column :rooms, :room_floor, :string
    add_column :rooms, :is_scheduled, :boolean, default: true
    add_column :rooms, :is_online, :boolean, default: false
    add_column :rooms, :dimensions, :text
    add_column :rooms, :area_of_space, :integer
  end
end
