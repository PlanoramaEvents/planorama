module MigrationHelpers
  module PlanoViews
    def self.create_views
      self.create_person_schedules
      self.create_person_and_exclusions
      self.create_room_allocations
      self.create_room_conflicts
      self.create_person_schedule_conflicts
      self.create_person_exclusion_conflicts
      self.create_person_back_to_back_to_back
      self.create_availability_conflicts
      self.create_session_conflicts
    end

    def self.create_person_schedules
      ActiveRecord::Base.connection.execute <<-SQL
        DROP VIEW IF EXISTS person_schedules;
      SQL

      query = <<-SQL.squish
        CREATE OR REPLACE VIEW person_schedules AS
          select
            CONCAT(p.id, ':', sa.id) as id,
            p.id as person_id ,
            p.name,
            p.published_name,
            p.con_state,
            sa.id as session_assignment_id,
            sart.id as session_assignment_role_type_id,
            sart.name as session_assignment_name,
            sart.role_type as session_assignment_role_type,
            sa.sort_order,
            sessions.id as session_id,
            sessions.title,
            sessions.start_time,
            (sessions.start_time + (sessions.duration || ' minute')::interval) as end_time,
            sessions.duration,
            sessions.room_id,
            areas.area_list,
            r.name as room_name,
            r.room_set_id,
            sessions.format_id,
            f.name as format_name
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
          right join
            rooms r on
            r.id = sessions.room_id
          right join
            formats f on
            f.id = sessions.format_id
          right join (
            select
              sessions.id as session_id,
              array_remove(
              	array_agg(areas.name),
              	NULL
              ) as area_list
              from sessions
              left join session_areas
              on session_areas.session_id = sessions.id
              right join areas on areas.id = session_areas.area_id
              group by sessions.id
          ) as areas on areas.session_id = sessions.id
          where
            sa.session_assignment_role_type_id is not null
            and sessions.room_id is not null
            and sessions.start_time is not null
      SQL
      ActiveRecord::Base.connection.execute(query)
    end

    def self.create_room_allocations
      query = <<-SQL.squish
        CREATE OR REPLACE VIEW room_allocations AS
        select
        	s.room_id,
          r.name as room_name,
          s.title as session_title,
        	s.start_time,
        	(s.start_time + (s.duration || ' minute')::interval) as end_time,
        	s.id as session_id
        from
        	sessions s
        inner join rooms r on
        	r.id = s.room_id
        	and s.start_time is not null;
      SQL
      ActiveRecord::Base.connection.execute(query)
    end

    def self.create_room_conflicts
      # Add room name, session name
      query = <<-SQL.squish
        CREATE OR REPLACE VIEW room_conflicts AS
          select
            CONCAT(b1.room_id, ':', b1.session_id) as id,
          	b1.room_id,
            b1.room_name,
            b1.session_title,
          	b1.session_id,
          	b1.start_time,
          	b1.end_time,
          	b2.session_id as conflicting_session_id,
            b2.session_title as conflicting_session_title,
          	b2.start_time as conflicting_session_start_time,
          	b2.end_time as conflicting_session_end_time,
          	case
          		when b1.start_time = b2.end_time or b2.start_time = b1.end_time
          		then true
          		else FALSE
          	end as back_to_back
          from
          	room_allocations b1
          inner join room_allocations b2
          on
          	b1.room_id = b2.room_id
          	and b1.session_id <> b2.session_id
          	and (b2.start_time >= b1.start_time and b2.start_time <= b1.end_time)
          order by
          	b1.room_id,
          	b1.start_time
      SQL
      ActiveRecord::Base.connection.execute(query)
    end

    def self.create_person_schedule_conflicts
      query = <<-SQL.squish
        CREATE OR REPLACE VIEW person_schedule_conflicts AS
          select
            CONCAT(ps1.person_id, ':', ps1.session_id, ':', ps2.session_id) as id,
            ps1.person_id,
            ps1.name,
            ps1.published_name,
            ps1.con_state,
            GREATEST(ps1.start_time, ps2.start_time) AS conflict_start_time,
            ps1.session_id,
            ps1.title,
            ps1.area_list,
            ps1.start_time,
            ps1.end_time,
            ps1.duration,
            ps1.session_assignment_id,
            ps1.session_assignment_role_type_id,
            ps1.session_assignment_name as session_assignment_name,
            ps1.session_assignment_role_type,
            ps1.room_id,
            ps1.room_name,
            ps2.session_id as conflict_session_id,
            ps2.title as conflict_session_title,
            ps2.area_list as conflict_area_list,
            ps2.end_time as conflict_end_time,
            ps2.duration as conflict_duration,
            ps2.session_assignment_role_type_id as conflict_session_assignment_role_type_id,
            ps2.session_assignment_role_type as conflict_session_assignment_role_type,
            ps2.session_assignment_name as conflict_session_assignment_name,
            ps2.room_id as conflict_room_id,
            ps2.room_name as conflict_room_name,
            case
            when
              ((ps2.start_time >= ps1.end_time) and (ps2.start_time <= (ps1.end_time + (40 || ' minute')::interval)))
              or
              ((ps1.start_time >= ps2.end_time) and (ps1.start_time <= (ps2.end_time + (40 || ' minute')::interval)))
            then true
            else FALSE
            end as back_to_back
          from
            person_schedules ps1
          join
            person_schedules ps2 on ps2.person_id = ps1.person_id
            and ps2.session_id != ps1.session_id
            and ps2.start_time >= ps1.start_time
            and (
              ps2.start_time <= ps1.end_time + (40 || ' minute')::interval
              or
              (
                ps2.end_time  >= ps1.start_time - (40 || ' minute')::interval and ps2.end_time <= ps1.end_time
              )
            )
          order by
            ps1.person_id
      SQL
      ActiveRecord::Base.connection.execute(query)
    end

    def self.create_person_and_exclusions
      query = <<-SQL.squish
        CREATE OR REPLACE VIEW person_and_exclusions AS
          select
            pe.exclusion_id,
          	pe.person_id,
          	s.id as session_id,
          	s.start_time,
            (s.start_time + (s.duration || ' minute')::interval) as end_time,
          	s.title
          from
          	person_exclusions pe
          left join exclusions_sessions es on
          	es.exclusion_id = pe.exclusion_id
          left join sessions s on
          	s.id = es.session_id
          where
          	session_id is not null
          order by
          	pe.person_id, session_id
      SQL
      ActiveRecord::Base.connection.execute(query)
    end

    def self.create_person_exclusion_conflicts
      query = <<-SQL.squish
        CREATE OR REPLACE VIEW person_exclusion_conflicts AS
          select
          	concat(person_schedules.person_id, ':', pe.exclusion_id, ':', person_schedules.session_id) as id,
          	person_schedules.person_id,
          	person_schedules.name,
          	person_schedules.published_name,
          	person_schedules.con_state,
          	pe.exclusion_id,
          	pe.session_id as excluded_session_id,
          	pe.title as excluded_session_title,
          	person_schedules.session_id,
          	person_schedules.title,
          	person_schedules.area_list,
          	person_schedules.start_time,
          	person_schedules.end_time,
          	person_schedules.duration,
          	person_schedules.session_assignment_role_type_id,
          	person_schedules.session_assignment_id,
          	person_schedules.session_assignment_name,
          	person_schedules.session_assignment_role_type
          from
          	person_schedules
          join
          	person_and_exclusions pe on pe.person_id = person_schedules.person_id
          	and person_schedules.session_id != pe.session_id
          	and pe.start_time >= person_schedules.start_time
          	and (
          	  person_schedules.start_time <= person_schedules.end_time
          	  or
          	  (
          	    person_schedules.end_time  >= person_schedules.start_time and pe.end_time <= person_schedules.end_time
          	  )
          	)
      SQL
      ActiveRecord::Base.connection.execute(query)
    end

    def self.create_person_back_to_back_to_back
      # check
      query = <<-SQL.squish
        CREATE OR REPLACE VIEW person_back_to_back_to_back AS
          select
            CONCAT(psc1.person_id, ':', psc1.session_id, ':', psc2.session_id, ':', psc2.conflict_session_id) as id,
            psc1.person_id,
            psc1.name,
            psc1.published_name,
            psc1.con_state,
            psc1.session_id,
            psc1.title,
            psc1.area_list,
            psc1.start_time,
            psc1.end_time,
            psc1.duration as duration,
            psc1.session_assignment_id,
            psc1.session_assignment_role_type_id,
            psc1.session_assignment_name as session_assignment_name,
            psc1.session_assignment_role_type,
            psc1.room_id,
            psc1.room_name,
            psc2.session_id as middle_session_id,
            psc2.title as middle_title,
            psc2.area_list as middle_area_list,
            psc2.start_time as middle_start_time,
            psc2.end_time as middle_end_time,
            psc2.duration as middle_duration,
            psc2.session_assignment_id as middle_session_assignment_id,
            psc2.session_assignment_role_type_id as middle_session_assignment_role_type_id,
            psc2.session_assignment_name as middle_session_assignment_name,
            psc2.session_assignment_role_type as middle_session_assignment_role_type,
            psc2.room_id as middle_room_id,
            psc2.room_name as middle_room_name,
            psc2.conflict_session_id,
            psc2.conflict_session_title,
            psc2.conflict_area_list,
            psc2.conflict_start_time,
            psc2.conflict_end_time,
            psc2.conflict_duration,
            psc2.conflict_session_assignment_role_type_id,
            psc2.conflict_session_assignment_role_type,
            psc2.conflict_session_assignment_name,
            psc2.conflict_room_id,
            psc2.conflict_room_name as conflict_room_name
          from
            person_schedule_conflicts psc1
          inner join person_schedule_conflicts psc2 on
            psc2.session_id = psc1.conflict_session_id
            and psc2.back_to_back = true
          where psc1.back_to_back = true
      SQL
      ActiveRecord::Base.connection.execute(query)
    end

    def self.create_availability_conflicts
      query = <<-SQL.squish
        CREATE OR REPLACE VIEW availability_conflicts AS
          select distinct
            CONCAT(session_assignments.id, ':', people.id, ':', sessions.id) as id,
            session_assignments.id as session_assignment_id,
            people.id as person_id,
            people.name as person_name,
            people.published_name as person_published_name,
            sessions.id as session_id,
            sessions.title as session_title,
            sessions.start_time as session_start_time,
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
      ActiveRecord::Base.connection.execute(query)
    end

    def self.create_session_conflicts
      # change conflict_type etc to polymorphic relationship
      # self.create_person_back_to_back_to_back
      query = <<-SQL.squish
        CREATE OR REPLACE VIEW session_conflicts AS
            select
              session_id,
              title as session_title,
              start_time as session_start_time,
              CAST(NULL as uuid) as room_id,
              NULL as room_name,
              person_id,
              name as person_name,
              published_name as person_published_name,
              session_assignment_id,
              session_assignment_role_type_id,
              session_assignment_name,
              excluded_session_id as conflict_session_id,
              excluded_session_title as conflict_session_title,
              CAST(NULL as uuid) as conflict_session_assignment_role_type_id,
              null as conflict_session_assignment_name,
              id as conflict_id,
              'person_exclusion_conflict' as conflict_type
            from person_exclusion_conflicts
          UNION
          select
            session_id,
            session_title,
            session_start_time,
            CAST(NULL as uuid) as room_id,
            NULL as room_name,
            person_id,
            person_name,
            person_published_name,
            session_assignment_id,
            session_assignment_role_type_id,
            session_assignment_name,
            CAST(NULL as uuid) as conflict_session_id,
            NULL as conflict_session_title,
            CAST(NULL as uuid) as conflict_session_assignment_role_type_id,
            null as conflict_session_assignment_name,
            id as conflict_id,
            'availability_conflict' as conflict_type
          from availability_conflicts
          UNION
          select
            session_id,
            session_title,
            start_time as session_start_time,
            room_id,
            room_name,
            CAST(NULL as uuid) as person_id,
            NULL as person_name,
            NULL as person_published_name,
            CAST(NULL as uuid) as session_assignment_id,
            CAST(NULL as uuid) as session_assignment_role_type_id,
            null as session_assignment_name,
            conflicting_session_id as conflict_session_id,
            conflicting_session_title as conflict_session_title,
            CAST(NULL as uuid) as conflict_session_assignment_role_type_id,
            null as conflict_session_assignment_name,
            id as conflict_id,
            'room_conflict' as conflict_type
          from room_conflicts
          where room_conflicts.back_to_back = false
          UNION
          select
            session_id,
            title as session_title,
            start_time as session_start_time,
            room_id,
            room_name,
            person_id,
            name as person_name,
            published_name as person_published_name,
            session_assignment_id,
            session_assignment_role_type_id,
            session_assignment_name,
            conflict_session_id,
            conflict_session_title,
            conflict_session_assignment_role_type_id,
            conflict_session_assignment_name,
            id as conflict_id,
            'person_schedule_conflict' as conflict_type
          from person_schedule_conflicts
          where person_schedule_conflicts.back_to_back = false
          UNION
        select
            session_id,
            title as session_title,
            start_time as session_start_time,
            room_id,
            room_name,
            person_id,
            name person_name,
            published_name as person_published_name,
            session_assignment_id,
            session_assignment_role_type_id,
            session_assignment_name,
            conflict_session_id,
            conflict_session_title,
            conflict_session_assignment_role_type_id,
            conflict_session_assignment_name,
            id as conflict_id,
            'person_back_to_back' as conflict_type
          from person_schedule_conflicts
          where person_schedule_conflicts.back_to_back = true
      SQL
      ActiveRecord::Base.connection.execute(query)
    end

    def self.drop_views
      ActiveRecord::Base.connection.execute <<-SQL
        DROP VIEW IF EXISTS session_conflicts;
      SQL
      ActiveRecord::Base.connection.execute <<-SQL
        DROP VIEW IF EXISTS availability_conflicts;
      SQL
      ActiveRecord::Base.connection.execute <<-SQL
        DROP VIEW IF EXISTS person_back_to_back_to_back;
      SQL
      ActiveRecord::Base.connection.execute <<-SQL
        DROP VIEW IF EXISTS person_exclusion_conflicts;
      SQL
      ActiveRecord::Base.connection.execute <<-SQL
        DROP VIEW IF EXISTS person_schedule_conflicts;
      SQL
      ActiveRecord::Base.connection.execute <<-SQL
        DROP VIEW IF EXISTS room_conflicts;
      SQL
      ActiveRecord::Base.connection.execute <<-SQL
        DROP VIEW IF EXISTS room_allocations;
      SQL
      ActiveRecord::Base.connection.execute <<-SQL
        DROP VIEW IF EXISTS person_and_exclusions;
      SQL
      ActiveRecord::Base.connection.execute <<-SQL
        DROP VIEW IF EXISTS person_schedules;
      SQL
    end
  end
end
