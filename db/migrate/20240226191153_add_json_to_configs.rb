class AddJsonToConfigs < ActiveRecord::Migration[6.1]
  def change
    add_column :configurations, :parameter_json, :jsonb, default: nil
  end
end
