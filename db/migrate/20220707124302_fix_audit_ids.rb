require 'webdack/uuid_migration/helpers'

class FixAuditIds < ActiveRecord::Migration[6.1]
  # fix columns in audit table to use the correct id type for the models
  def up
    columns_to_uuid :audit_people_versions, :item_id
    columns_to_uuid :audit_published_session_versions, :item_id
    columns_to_uuid :audit_session_versions, :item_id
    columns_to_uuid :audit_survey_versions, :item_id
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
