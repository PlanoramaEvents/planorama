class CreateConventionRoles < ActiveRecord::Migration[6.1]
  def change
    reversible do |change|
      change.up do
        # Do we need member?
        execute <<-SQL
          CREATE TYPE convention_role_enum AS ENUM ('admin', 'staff', 'participant');
        SQL
      end
      change.down do
        execute <<-SQL
          DROP TYPE convention_role_enum;
        SQL
      end
    end

    create_table :convention_roles, id: :uuid do |t|
      t.uuid :person_id

      t.integer :lock_version
      t.timestamps
    end
    add_column :convention_roles, :role, :convention_role_enum

    add_index :convention_roles, :person_id
  end
end
