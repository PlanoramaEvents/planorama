class CreateSessionAreas < ActiveRecord::Migration[6.0]
  def change
    create_table :session_areas, id: :uuid do |t|
      t.uuid :session_id
      t.uuid :area_id
      t.boolean :primary

      t.integer :lock_version
      t.timestamps
    end

    add_index :session_areas, [:session_id, :area_id], unique: true
  end
end
