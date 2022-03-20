class FixPeople < ActiveRecord::Migration[6.1]
  def change
    remove_column :people, :awards, :string, limit: 10000, default: nil
    rename_column :people, :langauges_fluent_in, :languages_fluent_in
  end
end
