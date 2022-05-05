require 'webdack/uuid_migration/helpers'

class RoomSetToUuid < ActiveRecord::Migration[6.1]
  def change
    reversible do |dir|
      dir.up do
        remove_reference :rooms, :room_set, null: true

        primary_key_to_uuid :room_sets

        add_reference :rooms, :room_set, null: true, foreign_key: true, type: :uuid
      end

      dir.down do
        raise ActiveRecord::IrreversibleMigration
      end
    end
  end
end
