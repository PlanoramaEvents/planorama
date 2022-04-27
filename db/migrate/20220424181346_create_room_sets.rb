class CreateRoomSets < ActiveRecord::Migration[6.1]
  def change
    create_table :room_sets do |t|
      t.string :name
      t.string :description
      t.integer :sort_order

      t.timestamps
    end
  end
end
