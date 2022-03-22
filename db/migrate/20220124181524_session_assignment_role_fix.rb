class SessionAssignmentRoleFix < ActiveRecord::Migration[6.0]
  def change
    change_column_null :session_assignments, :session_assignment_role_type_id, true
  end
end
