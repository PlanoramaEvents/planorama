class AddContactFlagToEmail < ActiveRecord::Migration[6.1]
  def change
    add_column :email_addresses, :iscontact, :boolean, default: false
  end
end
