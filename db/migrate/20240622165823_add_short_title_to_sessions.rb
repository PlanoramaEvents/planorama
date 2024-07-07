class AddShortTitleToSessions < ActiveRecord::Migration[6.1]
  def change
    add_column :sessions, :short_title, :string, default: nil, limit: 30
    add_column :published_sessions, :short_title, :string, default: nil, limit: 30
  end
end
