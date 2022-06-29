class AddIndexes < ActiveRecord::Migration[6.1]
  def change
    add_index :session_assignments, :session_assignment_role_type_id
    add_index :sessions, :room_id
  end
end
