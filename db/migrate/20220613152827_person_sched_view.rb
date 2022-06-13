class PersonSchedView < ActiveRecord::Migration[6.1]
  def up
    # This will be extended to union the other conflicts
    execute <<-SQL
      CREATE OR REPLACE VIEW person_schedule AS
        select
    SQL
  end

  def down
    execute <<-SQL
      DROP VIEW IF EXISTS person_schedule;
    SQL
  end
end

SELECT
  se.conference_id,
  se.person_id,
  se.session_id,
  se.appointment_id,
  se.role_id,
  se.visibility_code,
  ser.role_type AS schedule_group_type,
  ser.internal_name AS schedule_type,
  se.sort_order,
  se.created_at AS added_date_time,
  sd.start_date_time,
  se.leading_offset_mins,
  SUBTIME(sd.start_date_time, SEC_TO_TIME(se.leading_offset_mins)) AS personal_start_date_time,
  sd.end_date_time,
  se.trailing_offset_mins,
  ADDTIME(sd.end_date_time, SEC_TO_TIME(se.trailing_offset_mins)) AS personal_end_date_time,
  se.created_at,
  se.updated_at,
  if(cpsv.last_scan is not null, 1, 0) as scanned,
  cpsv.last_scan,
  cpsv.scanned_code,
  cpsv.nb_scans,
  cpsv.device_name
FROM schedule_entries se
  INNER JOIN PlannerPrime.schedule_entry_roles ser ON se.role_id = ser.id
  INNER JOIN sessions ON se.session_id = sessions.id
  INNER JOIN session_details sd ON sessions.latest_detail_id = sd.id
  LEFT JOIN cur_people_scans_view  cpsv ON se.person_id = cpsv.person_id and se.conference_id = cpsv.conference_id and se.session_id = cpsv.session_id
WHERE ser.role_scope = 'global'
and sessions.deleted_at is null
and se.deleted_at is null
UNION
SELECT
  se.conference_id,
  se.person_id,
  se.session_id,
  se.appointment_id,
  se.role_id,
  se.visibility_code,
  ser.role_type AS schedule_group_type,
  ser.internal_name AS schedule_type,
  se.sort_order,
  se.created_at AS added_date_time,
  appointments.start_date_time,
  se.leading_offset_mins,
  SUBTIME(appointments.start_date_time, SEC_TO_TIME(se.leading_offset_mins)) AS personal_start_date_time,
  appointments.end_date_time,
  se.trailing_offset_mins,
  ADDTIME(appointments.end_date_time, SEC_TO_TIME(se.trailing_offset_mins)) AS personal_end_date_time,
  se.created_at,
  se.updated_at,
  0 as scanned,
  null as last_scan,
  null as scanned_code,
  0 as nb_scans,
  null as device_name
FROM schedule_entries se
  INNER JOIN PlannerPrime.schedule_entry_roles ser ON se.role_id = ser.id
  INNER JOIN appointments ON se.appointment_id = appointments.id
WHERE ser.role_scope = 'global'
and se.deleted_at is null
