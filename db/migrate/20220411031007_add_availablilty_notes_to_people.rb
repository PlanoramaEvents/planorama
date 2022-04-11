class AddAvailabliltyNotesToPeople < ActiveRecord::Migration[6.1]
  def change
    add_column :people, :availability_notes, :string
  end
end
