class AddTechHotelNotes < ActiveRecord::Migration[6.1]
  def change
    add_column :sessions, :tech_notes, :text, default: nil
  end
end
