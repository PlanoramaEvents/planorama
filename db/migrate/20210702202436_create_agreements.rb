class CreateAgreements < ActiveRecord::Migration[6.0]
  def change
    create_table :agreements do |t|
      t.string :title
      t.text :terms
      t.string :type

      t.references :created_by, null: false
      t.references :updated_by, null: false

      t.timestamps
      t.integer :lock_version, default: 0
    end
  end
end
