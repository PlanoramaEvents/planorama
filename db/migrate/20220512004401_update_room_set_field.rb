require 'webdack/uuid_migration/helpers'

class UpdateRoomSetField < ActiveRecord::Migration[6.1]
  def change
    reversible do |dir|
      dir.up do
        columns_to_uuid :rooms, :room_set_id

      end

      dir.down do
        raise ActiveRecord::IrreversibleMigration
      end
    end
  end
end