class PersonExclusionConflicts < ActiveRecord::Migration[6.1]
  def up
    # This will be extended to union the other conflicts
    execute <<-SQL
      CREATE OR REPLACE VIEW person_exclusion_conflicts AS
       SELECT concat(person_schedules.person_id, ':', es.exclusion_id, ':', person_schedules.session_id) AS id,
          person_schedules.person_id,
          es.exclusion_id,
          es.session_id AS excluded_session_id,
          person_schedules.session_id,
          person_schedules.title,
          person_schedules.start_time,
          person_schedules.end_time,
          person_schedules.duration,
          person_schedules.session_assignment_role_type_id,
          person_schedules.session_assignment_name,
          person_schedules.session_assignment_role_type
         FROM (((public.person_schedules
           LEFT JOIN public.person_exclusions pe ON ((pe.person_id = person_schedules.person_id)))
           JOIN public.exclusions_sessions es ON ((es.exclusion_id = pe.exclusion_id)))
           LEFT JOIN public.sessions s ON ((s.id = es.session_id)))
        WHERE ((person_schedules.session_id <> s.id) AND (person_schedules.start_time >= s.start_time) AND ((person_schedules.start_time <= (s.start_time + ((s.duration || ' minute'::text))::interval)) OR ((person_schedules.end_time >= s.start_time) AND (person_schedules.end_time <= (s.start_time + ((s.duration || ' minute'::text))::interval)))));
    SQL
  end

  def down
    execute <<-SQL
      DROP VIEW IF EXISTS person_exclusion_conflicts;
    SQL
  end
end

('20220620181659'),
('20220620181701');
