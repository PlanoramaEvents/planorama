class CreateAreas < ActiveRecord::Migration[6.0]
  def change
    create_table :areas, id: :uuid do |t|
      t.string :name
      t.integer :sort_order
      t.timestamps
    end
  end
end
