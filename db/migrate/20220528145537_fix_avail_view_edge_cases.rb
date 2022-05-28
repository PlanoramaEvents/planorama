class FixAvailViewEdgeCases < ActiveRecord::Migration[6.1]
  def up
    execute <<-SQL
      CREATE OR REPLACE VIEW availability_conflicts AS
        select distinct
          session_assignments.id as session_assignment_id,
          people.id as person_id,
          sessions.id as session_id
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

  def down
    execute <<-SQL
      DROP VIEW IF EXISTS availability_conflicts;
    SQL
  end
end
