class CreateAreaUnits < ActiveRecord::Migration[6.1]
  def up
    create_table :area_units, id: :uuid do |t|
      t.string :name

      t.timestamps
    end
    add_column :area_units, :measurement_system, :measurement_system_enum, default: 'Metric'

    add_column :rooms, :area_unit_id, :uuid, null: true, default: nil
  end

  def down
    remove_column :rooms, :area_unit_id

    drop_table :area_units
  end
end
