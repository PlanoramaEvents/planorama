class AddRegAttendingStatusToPerson < ActiveRecord::Migration[6.1]
  def change
    add_column :people, :reg_attending_status, :string, default: nil
  end
end
