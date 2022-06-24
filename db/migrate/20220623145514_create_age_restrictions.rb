class CreateAgeRestrictions < ActiveRecord::Migration[6.1]
  def change
    create_table :age_restrictions, id: :uuid do |t|
      t.string :name, limit: 500

      t.integer :lock_version
      t.timestamps
    end

    add_column :sessions, :age_restriction_id, :uuid, null: true, default: nil
  end
end
