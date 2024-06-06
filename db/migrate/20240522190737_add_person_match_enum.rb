class AddPersonMatchEnum < ActiveRecord::Migration[6.1]
  def change
    reversible do |change|
      change.down do
        remove_column :people, :reg_match

        execute <<-SQL
          DROP TYPE reg_match_enum;
        SQL
      end
      change.up do
        execute <<-SQL
          CREATE TYPE reg_match_enum AS ENUM ('none', 'automatic', 'assisted', 'manual', 'self');
        SQL

        add_column :people, :reg_match, :reg_match_enum, default: 'none'
      end
    end
  end
end
