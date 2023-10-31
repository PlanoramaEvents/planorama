class CreateRegistrationSyncData < ActiveRecord::Migration[6.1]
  def change
    create_table :registration_sync_data, id: :uuid do |t|
      t.string :reg_id, index: true
      t.string :registration_number, index: true

      t.string :name
      t.string :email

      t.string :preferred_name, default: nil
      t.string :alternative_email, default: nil

      # t.uuid :matched_person, null: true, default: nil

      t.jsonb :raw_info, null: false, default: {}

      t.integer :lock_version
      t.timestamps
    end
  end
end
