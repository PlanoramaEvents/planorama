class UpdateSessionConflicts < ActiveRecord::Migration[6.1]
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
        UNION
        select
          session_id,
          room_id,
          null as person_id,
          null as session_assignment_id,
          conflicting_session_id as conflict_session_id,
          'room_conflict' as conflict_type
        from room_conflicts
        UNION
        select
          session_id,
          room_id,
          person_id,
          session_assignment_id,
          conflict_session_id,
          'person_session_conflict' as conflict_type
        from person_schedule_conflicts
        where person_schedule_conflicts.back_to_back = false
        UNION
        select
          session_id,
          room_id,
          person_id,
          session_assignment_id,
          conflict_session_id,
          'back_to_back' as conflict_type
        from person_schedule_conflicts
        where person_schedule_conflicts.back_to_back = true;
    SQL
  end

  def down
    execute <<-SQL
      DROP VIEW IF EXISTS session_conflicts;
    SQL
  end
end

# room conflict - room_conflicts
# person sched conflict - person_schedule_conflicts
# back to backs (from person sched conflict)
