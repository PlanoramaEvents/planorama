class FixParameterNames < ActiveRecord::Migration[6.0]
  def change
    remove_index :parameter_names, name: "parameter_description_UNIQUE"
  end
end
