class CreateBackToBackToBackView < ActiveRecord::Migration[6.1]
  def up
    # This will be extended to union the other conflicts
    execute <<-SQL
      CREATE OR REPLACE VIEW person_back_to_back_to_back AS
        select
          psc1.person_id,
          psc1.session_id,
          psc1.start_time,
          psc1.end_time,
          psc1.session_assignment_id,
          psc1.session_assignment_role_type_id,
          psc1.session_assignment_name as session_assignment_name,
          psc1.session_assignment_role_type,
          psc1.room_id,
          psc2.session_id as middle_session_id,
          psc2.start_time as middle_start_time,
          psc2.end_time as middle_end_time,
          psc2.session_assignment_id as middle_session_assignment_id,
          psc2.session_assignment_role_type_id as middle_session_assignment_role_type_id,
          psc2.session_assignment_name as middle_session_assignment_name,
          psc2.session_assignment_role_type as middle_session_assignment_role_type,
          psc2.room_id as middle_room_id,
          psc2.conflict_session_id,
          psc2.conflict_end_time,
          psc2.conflict_session_assignment_role_type_id,
          psc2.conflict_session_assignment_role_type,
          psc2.conflict_session_assignment_name,
          psc2.conflict_room_id,
          CONCAT(psc1.person_id, ':', psc1.session_id, ':', psc2.session_id, ':', psc2.conflict_session_id) as id
        from
          person_schedule_conflicts psc1
        inner join person_schedule_conflicts psc2 on
          psc2.session_id = psc1.conflict_session_id
          and psc2.back_to_back = true
        where psc1.back_to_back = true
    SQL
  end

  def down
    execute <<-SQL
      DROP VIEW IF EXISTS person_back_to_back_to_back;
    SQL
  end
end
