class AddDescAndSentToMailings < ActiveRecord::Migration[6.0]
  def change
    add_column :mailings, :description, :text
    add_column :mailings, :sent_by_id, :uuid, null: true, default: nil
  end
end
