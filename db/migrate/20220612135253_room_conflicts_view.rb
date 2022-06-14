
class RoomConflictsView < ActiveRecord::Migration[6.1]
  def up
    # This will be extended to union the other conflicts
    execute <<-SQL
      CREATE OR REPLACE VIEW room_conflicts AS
        select
        	b1.room_id,
        	b1.session_id,
        	b1.start_time,
        	b1.end_time,
        	b2.session_id as conflicting_session_id,
        	b2.start_time as conflicting_session_start_time,
        	b2.end_time as conflicting_session_end_time,
        	case
        		when b1.start_time = b2.end_time or b2.start_time = b1.end_time
        		then true
        		else FALSE
        	end as back_to_back
        from
        	room_allocations b1
        inner join room_allocations b2
        on
        	b1.room_id = b2.room_id
        	and b1.session_id <> b2.session_id
        	and (b1.start_time > b2.start_time and b1.start_time <= b2.end_time)
        order by
        	b1.room_id,
        	b1.start_time
    SQL
  end

  def down
    execute <<-SQL
      DROP VIEW IF EXISTS room_conflicts;
    SQL
  end
end
