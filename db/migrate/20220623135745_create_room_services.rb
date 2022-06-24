class CreateRoomServices < ActiveRecord::Migration[6.1]
  def change
    create_table :room_services, id: :uuid do |t|
      t.string :name, limit: 2000

      t.integer :lock_version
      t.timestamps
    end
  end
end
