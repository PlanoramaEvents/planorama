class AddWaitList < ActiveRecord::Migration[6.1]
  def up
    execute <<-SQL
      ALTER TYPE person_status_enum ADD VALUE 'wait_list' before 'invite_pending';
    SQL
  end

  # Removing values from enums is not supported
  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
