class CreateMagicLinks < ActiveRecord::Migration[6.0]
  def change
    create_table :magic_links do |t|
      t.references :person, null: false
      t.string :token, unique: true, null: false
      t.string :url, limit: 10000, default: nil
      t.datetime :expires_at, null: false

      t.timestamps
      t.integer :lock_version, default: 0
    end
  end
end
