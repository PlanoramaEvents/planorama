class CreateOauthIdentities < ActiveRecord::Migration[6.1]
  def change
    create_table :oauth_identities, id: :uuid do |t|
      t.string :provider
      t.uuid :person_id

      t.string :reg_id
      t.string :reg_number
      t.string :email      

      t.jsonb :raw_info, null: false, default: {}

      t.integer :lock_version
      t.timestamps
    end
  end
end
