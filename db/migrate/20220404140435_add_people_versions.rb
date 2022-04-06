class AddPeopleVersions < ActiveRecord::Migration[6.1]
  def change
    create_table :audit_people_versions do |t|
      t.string   :item_type, { null: false }
      t.bigint   :item_id,   null: false
      t.string   :event,     null: false
      t.string   :whodunnit
      t.json     :object
      t.datetime :created_at
      t.json     :object_changes
    end
    add_index :audit_people_versions, %i(item_type item_id)
  end
end
