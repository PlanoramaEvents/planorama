class AddIndexesToRegSyncData < ActiveRecord::Migration[6.1]
  def change
    add_index :registration_sync_data, :badge_name, using: :gin, opclass: :gin_trgm_ops
    add_index :registration_sync_data, :preferred_name, using: :gin, opclass: :gin_trgm_ops
    add_index :registration_sync_data, :alternative_email, using: :gin, opclass: :gin_trgm_ops
  end
end
