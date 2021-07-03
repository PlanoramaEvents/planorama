class AddLockversionToConfig < ActiveRecord::Migration[6.0]
  def change
    add_column :configurations, :lock_version, :integer, default: 0
  end
end
