class FixConflictView < ActiveRecord::Migration[6.1]
  def up
    person_sched_conflicts
    avail_conflicts

    execute <<-SQL
      DROP VIEW IF EXISTS session_conflicts;
    SQL

    execute <<-SQL
      CREATE OR REPLACE VIEW session_conflicts AS
        select
          session_id,
          CAST(NULL as uuid) as room_id,
          person_id,
          session_assignment_id,
          session_assignment_role_type_id,
          session_assignment_name,
          CAST(NULL as uuid) as conflict_session_id,
          CAST(NULL as uuid) as conflict_session_assignment_role_type_id,
          null as conflict_session_assignment_name,
          'availability' as conflict_type
        from availability_conflicts
        UNION
        select
          session_id,
          room_id,
          CAST(NULL as uuid) as person_id,
          CAST(NULL as uuid) as session_assignment_id,
          CAST(NULL as uuid) as session_assignment_role_type_id,
          null as session_assignment_name,
          conflicting_session_id as conflict_session_id,
          CAST(NULL as uuid) as conflict_session_assignment_role_type_id,
          null as conflict_session_assignment_name,
          'room_conflict' as conflict_type
        from room_conflicts
        where room_conflicts.back_to_back = false
        UNION
        select
          session_id,
          room_id,
          person_id,
          session_assignment_id,
          session_assignment_role_type_id,
          session_assignment_name,
          conflict_session_id,
          conflict_session_assignment_role_type_id,
          conflict_session_assignment_name,
          'person_session_conflict' as conflict_type
        from person_schedule_conflicts
        where person_schedule_conflicts.back_to_back = false
        UNION
        select
          session_id,
          room_id,
          person_id,
          session_assignment_id,
          session_assignment_role_type_id,
          session_assignment_name,
          conflict_session_id,
          conflict_session_assignment_role_type_id,
          conflict_session_assignment_name,
          'back_to_back' as conflict_type
        from person_schedule_conflicts
        where person_schedule_conflicts.back_to_back = true;
    SQL
  end

  def down
  end

  def person_sched_conflicts
    execute <<-SQL
      DROP VIEW IF EXISTS person_schedule_conflicts;
    SQL
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
        	ps1.session_assignment_name as session_assignment_name,
        	ps1.session_assignment_role_type,
        	ps1.room_id,
        	ps2.session_id as conflict_session_id,
        	ps2.end_time as conflict_end_time,
        	ps2.session_assignment_role_type_id as conflict_session_assignment_role_type_id,
        	ps2.session_assignment_role_type as conflict_session_assignment_role_type,
          ps2.session_assignment_name as conflict_session_assignment_name,
        	ps2.room_id as conflict_room_id,
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

  def avail_conflicts
    execute <<-SQL
      DROP VIEW IF EXISTS availability_conflicts;
    SQL

    execute <<-SQL
      CREATE OR REPLACE VIEW availability_conflicts AS
        select distinct
          session_assignments.id as session_assignment_id,
          people.id as person_id,
          sessions.id as session_id,
          session_assignments.session_assignment_role_type_id as session_assignment_role_type_id,
          sart.role_type as session_assignment_role_type,
          sart.name as session_assignment_name
        from
        	session_assignments
        inner join sessions on
        	sessions.id = session_assignments.session_id
        inner join people on
        	people.id = session_assignments.person_id
        inner join availabilities on
        	availabilities.person_id = people.id
        join
          session_assignment_role_type sart on
          sart.id = session_assignments.session_assignment_role_type_id
        where
          session_assignments.person_id = availabilities.person_id
        and
          session_assignments.session_assignment_role_type_id is not null
        and
          sessions.start_time is not null
        and
          sessions.room_id is not null
        and
          session_assignments.id not in
          (
          	select
          		session_assignments.id
          	from
          		session_assignments
          	inner join sessions on
          		sessions.id = session_assignments.session_id
          	inner join people on
          		people.id = session_assignments.person_id
          	inner join availabilities on
          		availabilities.person_id = people.id
          	where
          		session_assignments.person_id = availabilities.person_id
          		and session_assignments.session_assignment_role_type_id is not null
          		and (
          			sessions.start_time >= availabilities.start_time
          			and (sessions.start_time + (sessions.duration || ' minute')::INTERVAL) <= availabilities.end_time
          		)
          );
    SQL
  end
end
