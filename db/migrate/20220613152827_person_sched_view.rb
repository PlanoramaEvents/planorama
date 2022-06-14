
class PersonSchedView < ActiveRecord::Migration[6.1]
  def up
    # This will be extended to union the other conflicts
    execute <<-SQL
      CREATE OR REPLACE VIEW person_schedules AS
        select
          p.id as person_id ,
          p.name,
          p.published_name,
          sa.id as session_assignment_id,
          sart.id as session_assignment_role_type_id,
          sart.name as session_assignment_name,
          sart.role_type as session_assignment_role_type,
          sa.sort_order,
          sessions.id as session_id ,
          sessions.title,
          sessions.start_time,
          (sessions.start_time + (sessions.duration || ' minute')::interval) as end_time,
          sessions.room_id
        from
          session_assignments sa
        join
          session_assignment_role_type sart on
          sart.id = sa.session_assignment_role_type_id
          and sart.role_type = 'participant'
        join
          people p on
          p.id = sa.person_id
        left join
          sessions
          on sessions.id = sa.session_id
        where
          sa.session_assignment_role_type_id is not null
          and sessions.room_id is not null
          and sessions.start_time is not null
    SQL
  end

  def down
    execute <<-SQL
      DROP VIEW IF EXISTS person_schedules;
    SQL
  end
end
