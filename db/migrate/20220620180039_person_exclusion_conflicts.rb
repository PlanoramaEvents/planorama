class PersonExclusionConflicts < ActiveRecord::Migration[6.1]
  def up
    # This will be extended to union the other conflicts
    execute <<-SQL
      CREATE OR REPLACE VIEW person_exclusion_conflicts AS
      select
        CONCAT(person_schedules.person_id, ':', es.exclusion_id, ':', person_schedules.session_id) as id,
        person_schedules.person_id,
        es.exclusion_id,
        person_schedules.session_id,
        es.session_id as excluded_session_id
      from person_schedules
      left join person_exclusions pe on
        pe.person_id = person_schedules.person_id
      join exclusions_sessions es on
        es.exclusion_id = pe.exclusion_id
      left join sessions s on
        s.id = es.session_id
      where
        person_schedules.session_id != s.id
        and
        person_schedules.start_time >= s.start_time
        and (
          person_schedules.start_time <= (s.start_time + (s.duration || ' minute')::interval)
          or (
            person_schedules.end_time >= s.start_time and person_schedules.end_time <= (s.start_time + (s.duration || ' minute')::interval)
          )
        )
    SQL
  end

  def down
    execute <<-SQL
      DROP VIEW IF EXISTS person_exclusion_conflicts;
    SQL
  end
end
