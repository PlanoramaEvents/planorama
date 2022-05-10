class AddNameToPersonRole < ActiveRecord::Migration[6.1]
  def change
    reversible do |dir|
      dir.up do
        # PersonRole.delete_all
        execute <<-SQL
          DELETE FROM person_roles; 
        SQL
      end
    end

    add_column :person_roles, :name, :string
    change_column_null :person_roles, :name, false
  end
end
