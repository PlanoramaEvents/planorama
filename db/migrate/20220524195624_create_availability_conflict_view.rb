class CreateAvailabilityConflictView < ActiveRecord::Migration[6.1]
  def up
    execute <<-SQL
      CREATE OR REPLACE VIEW availability_conflicts AS
        select distinct
        	session_assignments.id as session_assignment_id,
        	people.id as person_id,
        	sessions.id as session_id
        from
        	"session_assignments"
        inner join "sessions" on
        	"sessions"."id" = "session_assignments"."session_id"
        inner join "people" on
        	"people"."id" = "session_assignments"."person_id"
        inner join "availabilities" on
        	"availabilities"."person_id" = "people"."id"
        inner join "session_assignment_role_type" on
        	"session_assignment_role_type"."id" = "session_assignments"."session_assignment_role_type_id"
        where
        	("sessions"."start_time" < "availabilities"."start_time"
        		or "sessions"."start_time" > "availabilities"."end_time")
        	and "session_assignments"."person_id" = "availabilities"."person_id"
        	and session_assignments.session_assignment_role_type_id is not null
          and session_assignment_role_type.name != 'Reserve';
    SQL
  end

  def down
    execute <<-SQL
      DROP VIEW IF EXISTS availability_conflicts;
    SQL
  end
end
