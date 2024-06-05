class AddSessionMetaData < ActiveRecord::Migration[6.1]
  def change
    add_column :audit_session_versions, :tags, :jsonb
    add_column :audit_published_session_versions, :tags, :jsonb
  end
end
