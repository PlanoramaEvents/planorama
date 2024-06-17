class AddBadgenameToRegSyncData < ActiveRecord::Migration[6.1]
  def change
    add_column :registration_sync_data, :badge_name, :string, default: nil
  end
end
