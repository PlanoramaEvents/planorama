class AddRegIdToPerson < ActiveRecord::Migration[6.1]
  def change
    # This is the id from the registration system
    add_column :people, :reg_id, :string, index: true, null: true, default: nil
  end
end
