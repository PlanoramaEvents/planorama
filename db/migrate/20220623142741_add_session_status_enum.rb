class AddSessionStatusEnum < ActiveRecord::Migration[6.1]
  def change
    reversible do |change|
      change.down do
        remove_column :sessions, :status

        execute <<-SQL
          DROP TYPE session_status_enum;
        SQL
      end
      change.up do
        execute <<-SQL
          CREATE TYPE session_status_enum AS ENUM ('draft', 'reviewed', 'revised', 'dropped');
        SQL

        add_column :sessions, :status, :session_status_enum, default: 'draft'
      end
    end
  end
end
