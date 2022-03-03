class CreatePersonGroups < ActiveRecord::Migration[6.1]
  def change
    reversible do |change|
      change.up do
        # Do we need member?
        execute <<-SQL
          CREATE TYPE person_group_enum AS ENUM ('admin', 'staff', 'participant');
        SQL
      end
      change.down do
        execute <<-SQL
          DROP TYPE person_group_enum;
        SQL
      end
    end

    create_table :person_groups, id: :uuid do |t|
      t.uuid :person_id

      t.integer :lock_version
      t.timestamps
    end
    add_column :person_groups, :group, :person_group_enum

    add_index :person_groups, :person_id
  end
end
