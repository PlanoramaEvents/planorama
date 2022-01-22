class ChangeToSessions < ActiveRecord::Migration[6.0]
  def change
    rename_table :programme_items, :sessions
    rename_table :programme_assignments, :session_assignments
    rename_table :published_programme_items, :published_sessions
    rename_table :published_programme_assignments, :published_session_assignments

    rename_table :programme_assignment_role_type, :session_assignment_role_type

    rename_column :published_sessions, :programme_item_id, :session_id

    rename_column :session_assignments, :programme_item_id, :session_id
    rename_column :session_assignments, :programme_assignment_role_type_id, :session_assignment_role_type_id

    rename_column :published_session_assignments, :programme_assignment_id, :session_assignment_id
    rename_column :published_session_assignments, :programme_item_id, :published_session_id
    rename_column :published_session_assignments, :programme_assignment_role_type_id, :session_assignment_role_type_id
  end
end
