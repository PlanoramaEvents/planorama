class AddDemographicFields < ActiveRecord::Migration[6.1]
  def change
    add_column :people, :excluded_demographic_categories, :string, default: nil
    add_column :people, :global_diaspora, :string, default: nil
    add_column :people, :non_anglophone, :string, default: nil
  end
end
