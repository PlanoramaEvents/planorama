class RenameAgreementType < ActiveRecord::Migration[6.0]
  def change
    rename_column :agreements, :type, :agreement_type
  end
end
