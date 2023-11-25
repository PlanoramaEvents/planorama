class AddRegSyncTimeToPerson < ActiveRecord::Migration[6.1]
  def change
    add_column :people, :date_reg_synced, :datetime, null: true, default: nil
  end
end
