class AddLockVersionToIntegrations < ActiveRecord::Migration[6.1]
  def change
    add_column :integrations, :lock_version, :integer, default: 0
  end
end
