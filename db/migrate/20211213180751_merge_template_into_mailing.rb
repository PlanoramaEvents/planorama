class MergeTemplateIntoMailing < ActiveRecord::Migration[6.0]
  def change

    add_column :mailings, :subject, :string
    add_column :mailings, :content, :text
    add_column :mailings, :survey_id, :uuid, null: true, default: nil
    add_column :mailings, :date_sent, :datetime, null: true, default: nil
    add_column :mailings, :transiton_invite_status, :invite_status_enum, default: 'not_set'

    remove_column :mailings, :mail_template_id, :boolean

    drop_table :mail_templates
  end
end
