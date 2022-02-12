require 'webdack/uuid_migration/helpers'

class UseUidsForTags < ActiveRecord::Migration[6.0]
  def change
    reversible do |dir|
      dir.up do
        primary_key_to_uuid :tag_contexts
        primary_key_to_uuid :tags
        primary_key_to_uuid :taggings

        columns_to_uuid :taggings, :tag_id, :tagger_id, :taggable_id
      end

      dir.down do
        raise ActiveRecord::IrreversibleMigration
      end
    end
  end
end
