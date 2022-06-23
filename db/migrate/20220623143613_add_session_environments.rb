class AddSessionEnvironments < ActiveRecord::Migration[6.1]
  def change
    reversible do |change|
      change.down do
        remove_column :sessions, :environment

        execute <<-SQL
          DROP TYPE session_environments_enum;
        SQL
      end
      change.up do
        execute <<-SQL
          CREATE TYPE session_environments_enum AS ENUM ('unknown', 'in_person', 'hybrid', 'virtual');
        SQL

        add_column :sessions, :environment, :session_environments_enum, default: 'unknown'
      end
    end
  end
end
