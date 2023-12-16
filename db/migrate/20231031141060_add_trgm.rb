class AddTrgm < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def change
    reversible do |dir|
      dir.up do
        # Add GIN for better text searching
        enable_extension 'pg_trgm'
      end

      dir.down do
        raise ActiveRecord::IrreversibleMigration
      end
    end
  end
end
