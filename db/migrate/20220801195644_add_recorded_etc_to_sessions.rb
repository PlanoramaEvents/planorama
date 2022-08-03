class AddRecordedEtcToSessions < ActiveRecord::Migration[6.1]
  def change
    add_column :sessions, :recorded, :boolean, default: false, null: false
    add_column :sessions, :streamed, :boolean, default: false, null: false

    add_column :published_sessions, :recorded, :boolean, default: false, null: false
    add_column :published_sessions, :streamed, :boolean, default: false, null: false
  end
end
