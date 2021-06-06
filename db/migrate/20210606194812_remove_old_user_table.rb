class RemoveOldUserTable < ActiveRecord::Migration[6.0]
  def self.up
    drop_table :user_role_assignments
    drop_table :user_roles
    drop_table :users
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
