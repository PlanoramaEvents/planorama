class AdjustMailings < ActiveRecord::Migration[6.0]
  def change
    add_column :mailings, :title, :string
    remove_column :mailings, :scheduled, :boolean
    remove_column :mailings, :mailing_number, :integer
    remove_column :mail_templates, :title, :string
  end
end
