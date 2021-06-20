class CreatePersonRoles < ActiveRecord::Migration[6.0]
  def change
    create_table :person_roles do |t|
      t.references :person, index: true, null: false, foreign_key: true

      t.timestamps
    end
  end
end
