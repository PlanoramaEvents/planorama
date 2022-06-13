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
  #
  # SELECT
  #   psv1.conference_id,
  #   psv1.person_id,
  #   GREATEST(psv1.personal_start_date_time, psv2.personal_start_date_time) AS conflict_start_date_time,
  #   psv1.session_id AS session_id,
  #   psv1.role_id AS role_id,
  #   psv1.schedule_type AS schedule_type,
  #   psv1.schedule_group_type AS schedule_group_type,
  #   psv1.personal_start_date_time AS start_date_time,
  #   psv1.personal_end_date_time AS end_date_time,
  #   psv1.visibility_code AS visibility_code,
  #   psv2.session_id AS conflicting_session_id,
  #   psv2.role_id AS conflicting_role_id,
  #   psv2.schedule_type AS conflicting_schedule_type,
  #   psv2.schedule_group_type AS conflicting_schedule_group_type,
  #   psv2.personal_start_date_time AS conflicting_start_date_time,
  #   psv2.personal_end_date_time AS conflicting_end_date_time,
  #   psv2.visibility_code AS conflicting_visibility_code,
  #   IF(psv1.personal_start_date_time = psv2.personal_end_date_time OR psv1.personal_end_date_time = psv2.personal_start_date_time, 1, 0) AS back_to_back
  # FROM
  #   cur_people_schedules_view psv1
  #   JOIN cur_people_schedules_view psv2 ON psv1.person_id = psv2.person_id
  #     AND psv2.conference_id = psv1.conference_id
  #     AND psv1.session_id <> psv2.session_id
  #     AND psv1.personal_start_date_time >= psv2.personal_start_date_time
  #     AND (
  #       psv1.personal_start_date_time <= psv2.personal_end_date_time
  #       OR psv1.personal_end_date_time BETWEEN psv2.personal_start_date_time AND psv2.personal_end_date_time
  #     )
  # GROUP BY psv1.person_id, IF(psv1.session_id > psv2.session_id, CONCAT(psv2.session_id, ',', psv1.session_id), CONCAT(psv1.session_id, ',', psv2.session_id))
  # ORDER BY psv1.conference_id, psv1.person_id, conflict_start_date_time
