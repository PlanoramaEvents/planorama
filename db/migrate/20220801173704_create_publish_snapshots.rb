class CreatePublishSnapshots < ActiveRecord::Migration[6.1]
  def change
    create_table :publish_snapshots, id: :uuid do |t|
      t.uuid :publication_date_id
      t.string :label
      t.jsonb :snapshot

      t.timestamps
    end
  end
end
