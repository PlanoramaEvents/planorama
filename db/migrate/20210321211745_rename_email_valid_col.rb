class RenameEmailValidCol < ActiveRecord::Migration[6.0]
  def change
    rename_column :email_addresses, :valid, :is_valid
  end
end
