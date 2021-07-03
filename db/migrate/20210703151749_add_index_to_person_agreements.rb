class AddIndexToPersonAgreements < ActiveRecord::Migration[6.0]
  def change
    add_index :person_agreements, [:person_id, :agreement_id], unique: true
  end
end
