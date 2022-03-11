class AdjustAgreements < ActiveRecord::Migration[6.1]
  def change
    # Add to enum none
    up_only do
      execute <<-SQL
        ALTER TYPE agreement_target ADD VALUE 'none' BEFORE 'member';
      SQL
    end
    # Add description
    add_column :agreements, :description, :string, limit: 10000, default: nil
  end
end
