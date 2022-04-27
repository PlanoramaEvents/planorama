class AddAddressToVenues < ActiveRecord::Migration[6.1]
  def change
    add_column :venues, :address, :string
  end
end
