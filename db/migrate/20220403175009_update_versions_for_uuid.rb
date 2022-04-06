require 'webdack/uuid_migration/helpers'

class UpdateVersionsForUuid < ActiveRecord::Migration[6.1]
  def change
    reversible do |dir|
      dir.up do
        columns_to_uuid :versions, :item_id
      end

      dir.down do
        raise ActiveRecord::IrreversibleMigration
      end
    end
  end
end
