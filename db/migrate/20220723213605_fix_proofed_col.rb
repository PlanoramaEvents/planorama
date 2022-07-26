class FixProofedCol < ActiveRecord::Migration[6.1]
  def change
    # proofed boolean col needs to default to false
    change_column_null :sessions, :proofed, false, false
    change_column :sessions, :proofed, :boolean, default: false, null: false
  end
end
