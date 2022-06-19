
class PersonSchedConflictsView < ActiveRecord::Migration[6.1]
  def up
    # This will be extended to union the other conflicts
    execute <<-SQL
      CREATE OR REPLACE VIEW person_schedule_conflicts AS
        select
        	ps1.person_id,
        	GREATEST(ps1.start_time, ps2.start_time) AS conflict_start_time,
        	ps1.session_id,
        	ps1.start_time,
        	ps1.end_time,
          ps1.session_assignment_id,
        	ps1.session_assignment_role_type_id,
        	ps1.session_assignment_name,
        	ps1.session_assignment_role_type,
        	ps1.room_id,
        	ps2.session_id as conflict_session_id,
        	ps2.end_time as conflict_end_time,
        	ps1.session_assignment_role_type_id as conflict_session_assignment_role_type_id,
        	ps1.session_assignment_name as conflict_session_assignment_name,
        	ps1.session_assignment_role_type as conflict_session_assignment_role_type,
        	ps1.room_id as conflict_room_id,
          case
          when ps1.start_time = ps2.end_time or ps2.start_time = ps1.end_time
        		then true
        		else FALSE
        	end as back_to_back
        from
        	person_schedules ps1
        join
        	person_schedules ps2 on ps2.person_id = ps1.person_id
        	and ps2.session_id != ps1.session_id
        	and ps1.start_time >= ps2.start_time
        	and (
        		ps1.start_time <= ps2.end_time
        		or
        		(
         			ps1.end_time >= ps2.start_time and ps1.end_time <= ps2.end_time
        		)
        	)
        order by
        	ps1.person_id,
        	GREATEST(ps1.start_time, ps2.start_time)
    SQL
  end

  def down
    execute <<-SQL
      DROP VIEW IF EXISTS person_schedule_conflicts;
    SQL
  end
end
