class AddSentExternalToPublicationDates < ActiveRecord::Migration[6.1]
  def change
    add_column :publication_dates, :sent_external, :boolean, default: false, null: false
    add_column :publication_dates, :lock_version, :integer, default: 0
  end
end
