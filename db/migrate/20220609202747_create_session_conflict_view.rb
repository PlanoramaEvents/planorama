class CreateSessionConflictView < ActiveRecord::Migration[6.1]
  def up
    # This will be extended to union the other conflicts
    execute <<-SQL
      CREATE OR REPLACE VIEW session_conflicts AS
        select
          session_id,
          null as room_id,
          person_id,
          session_assignment_id,
          null as conflict_session_id,
          'availability' as conflict_type
        from availability_conflicts
    SQL
  end

  def down
    execute <<-SQL
      DROP VIEW IF EXISTS session_conflicts;
    SQL
  end
end
