class AddSortToRoleType < ActiveRecord::Migration[6.1]
  def change
    add_column :session_assignment_role_type, :sort_order, :integer
  end
end
