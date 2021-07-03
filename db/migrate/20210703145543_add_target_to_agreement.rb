class AddTargetToAgreement < ActiveRecord::Migration[6.0]
  def up
    execute <<-SQL
      CREATE TYPE agreement_target AS ENUM ('member', 'staff', 'all');
    SQL
    add_column :agreements, :target, :agreement_target
    add_index :agreements, :target
  end

  def down
    remove_column :agreements, :target
    execute <<-SQL
      DROP TYPE agreement_target;
    SQL
  end
end
