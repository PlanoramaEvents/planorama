class RelaxSetupConstraint < ActiveRecord::Migration[6.1]
  def change
    remove_reference :rooms, :room_set, null: false , foreign_key: true
    add_reference :rooms, :room_set, null: true , foreign_key: true
  end
end
