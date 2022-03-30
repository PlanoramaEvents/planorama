class CreateExclusions < ActiveRecord::Migration[6.1]
  def change
    create_table :exclusions, id: :uuid do |t|
      t.string :title, limit: 800, null: false
      t.integer :lock_version
      t.timestamps
    end    
  end
end
