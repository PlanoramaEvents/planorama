class AddFieldsToPublishedSession < ActiveRecord::Migration[6.1]
  def change
    add_column :published_sessions, :environment, :session_environments_enum, default: 'unknown'
    add_column :published_sessions, :minors_participation, :jsonb
  end
end
