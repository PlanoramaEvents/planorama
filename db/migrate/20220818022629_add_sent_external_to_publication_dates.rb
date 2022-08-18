class AddSentExternalToPublicationDates < ActiveRecord::Migration[6.1]
  def change
    add_column :publication_dates, :sent_external, :boolean, default: false, null: false
  end
end
