class AddDurationToSchedView < ActiveRecord::Migration[6.1]
  def up
    # This will be extended to union the other conflicts
    execute <<-SQL
      CREATE OR REPLACE VIEW person_schedules AS
        SELECT p.id AS person_id,
           p.name,
           p.published_name,
           sa.id AS session_assignment_id,
           sart.id AS session_assignment_role_type_id,
           sart.name AS session_assignment_name,
           sart.role_type AS session_assignment_role_type,
           sa.sort_order,
           sessions.id AS session_id,
           sessions.title,
           sessions.start_time,
           (sessions.start_time + ((sessions.duration || ' minute'::text))::interval) AS end_time,
           sessions.room_id,
           sessions.format_id,
           concat(p.id, ':', sa.id) AS id,
           sessions.duration
          FROM (((public.session_assignments sa
            JOIN public.session_assignment_role_type sart ON (((sart.id = sa.session_assignment_role_type_id) AND (sart.role_type = 'participant'::public.assignment_role_enum))))
            JOIN public.people p ON ((p.id = sa.person_id)))
            LEFT JOIN public.sessions ON ((sessions.id = sa.session_id)))
         WHERE ((sa.session_assignment_role_type_id IS NOT NULL) AND (sessions.room_id IS NOT NULL) AND (sessions.start_time IS NOT NULL));
    SQL
  end

  def down
    execute <<-SQL
      DROP VIEW IF EXISTS person_schedules;
    SQL
  end
end
