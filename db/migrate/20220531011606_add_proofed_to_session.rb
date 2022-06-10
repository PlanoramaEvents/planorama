class AddProofedToSession < ActiveRecord::Migration[6.1]
  def change
    add_column :sessions, :proofed, :boolean
  end
end
