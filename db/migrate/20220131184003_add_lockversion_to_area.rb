class AddLockversionToArea < ActiveRecord::Migration[6.0]
  def change
    add_column :areas, :lock_version, :integer, default: 0

    # add an unique index
    add_index :areas, :name, unique: true
  end
end
