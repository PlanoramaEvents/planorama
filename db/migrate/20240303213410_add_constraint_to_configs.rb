class AddConstraintToConfigs < ActiveRecord::Migration[6.1]
  def up
    change_column_null :configurations, :parameter_value, true
    execute "ALTER TABLE configurations ADD CONSTRAINT param_exists CHECK (parameter_json is not null or parameter_value is not null);"
  end

  def down
    execute "ALTER TABLE configurations DROP CONSTRAINT param_exists;"
    change_column_null :configurations, :parameter_value, false
  end
end
