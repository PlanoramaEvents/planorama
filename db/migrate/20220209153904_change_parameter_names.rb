class ChangeParameterNames < ActiveRecord::Migration[6.0]
  def change
    add_column :parameter_names, :parameter_type, :string, default: 'String'
  end
end
