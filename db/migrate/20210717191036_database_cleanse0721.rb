class DatabaseCleanse0721 < ActiveRecord::Migration[6.0]
  # Remove unused old structures
  def up
    remove_column :programme_items, :setup_type_id, :integer
    remove_column :rooms, :setup_type_id, :integer

    drop_table :excluded_items_survey_maps
    drop_table :exclusions
    drop_table :job_infos
    drop_table :notes
    drop_table :pending_import_people
    drop_table :phone_numbers
    drop_table :postal_addresses
    drop_table :setup_types
    drop_table :site_configs
    drop_table :ui_preferences
    drop_table :available_dates
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
