class CreatePersonAgreements < ActiveRecord::Migration[6.0]
  def change
    create_table :person_agreements do |t|
      t.references :person, null: false
      t.references :agreement, null: false

      t.boolean :signed, default: false
      t.datetime :agreed_on, null: false

      t.timestamps
      t.integer :lock_version, default: 0
    end
  end
end
