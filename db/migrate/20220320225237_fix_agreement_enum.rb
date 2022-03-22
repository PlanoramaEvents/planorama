class FixAgreementEnum < ActiveRecord::Migration[6.1]
  def change
    # Add to enum none
    up_only do
      execute <<-SQL
        ALTER TYPE agreement_target ADD VALUE 'participant' AFTER 'none';
      SQL
    end
    # Add description
  end
end
