class CreateAvailabilities < ActiveRecord::Migration[6.1]
  def change
    create_table :availabilities, id: :uuid do |t|
      t.uuid :person_id

      t.datetime :start_time
      t.datetime :end_time

      t.integer :lock_version
      t.timestamps
    end
  end
end
