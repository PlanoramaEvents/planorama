class CreateCuratedTags < ActiveRecord::Migration[6.1]
  def change
    create_table :curated_tags, id: :uuid do |t|
      t.string :name, limit: 190
      t.string :context, limit: 190

      t.integer :lock_version
      t.timestamps
    end
  end
end
