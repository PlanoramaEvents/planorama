class AddMissingLockVersions < ActiveRecord::Migration[6.1]
  def change
    add_column :application_roles, :lock_version, :integer, default: 0
    add_column :room_sets, :lock_version, :integer, default: 0
  end
end
