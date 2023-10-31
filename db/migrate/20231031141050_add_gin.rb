class AddGin < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def change
    reversible do |dir|
      dir.up do
        # Add GIN for better text searching
        enable_extension 'btree_gin'
      end

      dir.down do
        raise ActiveRecord::IrreversibleMigration
      end
    end
  end
end
