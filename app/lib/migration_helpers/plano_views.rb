module MigrationHelpers
  module PlanoViews
    def self.create_views
      self.create_person_schedules
      self.create_person_and_exclusions
      self.create_room_allocations
      self.create_room_conflicts
      self.create_person_schedule_conflicts
      self.create_person_back_to_back
      self.create_person_exclusion_conflicts
      self.create_person_back_to_back_to_back
      self.create_availability_conflicts
      self.create_session_conflicts

      # view for reg matching
      self.create_registration_sync_matches
      self.create_filtered_registration_sync_matches
      self.create_registration_map_counts
      self.create_registration_map_reg_counts
      self.create_registration_map_people_counts
    end

    def self.create_filtered_registration_sync_matches
      query = <<-SQL.squish
        CREATE OR REPLACE VIEW filtered_registration_sync_matches AS
          select * from registration_sync_matches rsm 
          where rsm.reg_id not in (select p2.reg_id from people p2 where  p2.reg_id is not null)
      SQL

      ActiveRecord::Base.connection.execute(query)
    end

    def self.create_registration_sync_matches
      query = <<-SQL.squish
        DROP materialized VIEW IF EXISTS registration_sync_matches;
        CREATE MATERIALIZED VIEW registration_sync_matches AS
          select p.name, null as email, p.id as pid, rsd.reg_id, rsd.id as rid, 'name' as mtype
          from people p 
          join registration_sync_data rsd
          on 
          (
            rsd."name" ilike p.name OR
            rsd."preferred_name" ilike p.name OR
            rsd."badge_name" ilike p.name
            or rsd."name" ilike p.pseudonym
            or rsd."preferred_name" ilike p.pseudonym
            or rsd."badge_name" ilike p.pseudonym
          )
          where
          concat(p.id, '-', rsd.reg_id) not in 
          (select concat(drsm.person_id, '-' , drsm.reg_id) from dismissed_reg_sync_matches drsm)
          union
          select null as name, e.email, e.person_id as pid, rsd2.reg_id, rsd2.id as rid, 'email' as mtype
          from email_addresses e
          join registration_sync_data rsd2 
          on 
          (
            rsd2."email" ilike e.email or
            rsd2."alternative_email" ilike e.email
          )
          where e.isdefault = true
          and 
          concat(e.person_id, '-', rsd2.reg_id) not in 
          (select concat(drsm.person_id, '-' , drsm.reg_id) from dismissed_reg_sync_matches drsm);
        CREATE INDEX matches_reg_id ON registration_sync_matches (reg_id);
        CREATE INDEX matches_pid ON registration_sync_matches (pid);
      SQL

      ActiveRecord::Base.connection.execute(query)
    end

    def self.refresh_registration_sync_matches
      query = <<-SQL.squish
        REFRESH MATERIALIZED VIEW registration_sync_matches;
      SQL

      ActiveRecord::Base.connection.execute(query)
    end

    def self.create_registration_map_counts
      query = <<-SQL.squish
        CREATE OR REPLACE VIEW registration_map_counts AS
          select rsm.reg_id, rsm.pid, count(rsm.pid) as sub_count 
          from registration_sync_matches rsm
          where rsm.pid not in (select person_id from dismissed_reg_sync_matches)
          and rsm.reg_id not in (select reg_id from dismissed_reg_sync_matches)
          group by rsm.reg_id, rsm.pid
      SQL

      ActiveRecord::Base.connection.execute(query)
    end

    def self.create_registration_map_reg_counts
      query = <<-SQL.squish
        CREATE OR REPLACE VIEW registration_map_reg_counts AS
          select reg_id, count(reg_id) as count from registration_map_counts
          group by reg_id
      SQL

      ActiveRecord::Base.connection.execute(query)
    end

    def self.create_registration_map_people_counts
      query = <<-SQL.squish
        CREATE OR REPLACE VIEW registration_map_people_counts AS
          select pid, count(pid) as count from registration_map_counts
          group by pid
      SQL

      ActiveRecord::Base.connection.execute(query)
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
            p.can_share,
            p.pronouns,
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
            sessions.format_id,
            sessions.participant_notes,
            sessions.description,
            sessions.environment,
            sessions.status,
            sessions.streamed,
            sessions.recorded,
            case
            when sa.updated_at > sessions.updated_at
          		then sa.updated_at
          		else sessions.updated_at
          	end as updated_at
          from
            session_assignments sa
          join
            session_assignment_role_type sart on
            sart.id = sa.session_assignment_role_type_id
            and sart.role_type = 'participant' AND sart.name != 'Reserve'
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
            and sa.state != 'rejected';
      SQL
      ActiveRecord::Base.connection.execute(query)
    end

    def self.create_room_allocations
      query = <<-SQL.squish
        CREATE OR REPLACE VIEW room_allocations AS
        select
        	s.room_id,
          s.title as session_title,
        	s.start_time,
        	(s.start_time + (s.duration || ' minute')::interval) as end_time,
          s.duration,
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
            CONCAT(b1.room_id, ':', b1.session_id, ':', b2.session_id) as id,
          	b1.room_id,
            b1.session_title,
          	b1.session_id,
          	b1.start_time,
          	b1.end_time,
            b1.duration,
          	b2.session_id as conflicting_session_id,
            b2.session_title as conflicting_session_title,
          	b2.start_time as conflicting_session_start_time,
            b2.duration as conflicting_session_duration,
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
      # change for back to backs
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
            ps1.start_time,
            ps1.end_time,
            ps1.duration,
            ps1.session_assignment_id,
            ps1.session_assignment_role_type_id,
            ps1.session_assignment_name as session_assignment_name,
            ps1.session_assignment_role_type,
            ps1.room_id,
            ps2.session_id as conflict_session_id,
            ps2.title as conflict_session_title,
            ps2.end_time as conflict_end_time,
            ps2.duration as conflict_duration,
            ps2.session_assignment_role_type_id as conflict_session_assignment_role_type_id,
            ps2.session_assignment_role_type as conflict_session_assignment_role_type,
            ps2.session_assignment_name as conflict_session_assignment_name,
            ps2.room_id as conflict_room_id
          from
            person_schedules ps1
          join
            person_schedules ps2 on ps2.person_id = ps1.person_id
            and ps2.session_id != ps1.session_id
            and ps2.start_time >= ps1.start_time
            and (
              ps2.start_time < ps1.end_time
              or
              (
                ps2.end_time  > ps1.start_time and ps2.end_time <= ps1.end_time
              )
            );
      SQL
      ActiveRecord::Base.connection.execute(query)
    end

    def self.create_person_back_to_back
      query = <<-SQL.squish
        CREATE OR REPLACE VIEW person_back_to_back AS
          select
            CONCAT(ps1.person_id, ':', ps1.session_id, ':', ps2.session_id) as id,
            ps1.person_id,
            ps1.name,
            ps1.published_name,
            ps1.con_state,
            ps2.start_time AS conflict_start_time,
            ps1.session_id,
            ps1.title,
            ps1.start_time,
            ps1.end_time,
            ps1.duration,
            ps1.session_assignment_id,
            ps1.session_assignment_role_type_id,
            ps1.session_assignment_name as session_assignment_name,
            ps1.session_assignment_role_type,
            ps1.room_id,
            ps2.session_id as conflict_session_id,
            ps2.title as conflict_session_title,
            ps2.end_time as conflict_end_time,
            ps2.duration as conflict_duration,
            ps2.session_assignment_role_type_id as conflict_session_assignment_role_type_id,
            ps2.session_assignment_role_type as conflict_session_assignment_role_type,
            ps2.session_assignment_name as conflict_session_assignment_name,
            ps2.room_id as conflict_room_id
          from
            person_schedules ps1
          join
            person_schedules ps2 on ps2.person_id = ps1.person_id
            and ps2.session_id != ps1.session_id
          where
            (ps2.start_time >= ps1.end_time) and (ps2.start_time <= (ps1.end_time + (40 || ' minute')::interval));
      SQL
      # or
      # ((ps1.start_time >= ps2.end_time) and (ps1.start_time <= (ps2.end_time + (40 || ' minute')::interval)))

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
        	concat(person_schedules.person_id, ':', es.exclusion_id, ':', person_schedules.session_id) as id,
        	person_schedules.person_id,
        	person_schedules.name,
        	person_schedules.published_name,
        	person_schedules.con_state,
        	es.exclusion_id,
        	es.session_id as excluded_session_id,
        	s.title as excluded_session_title,
        	person_schedules.session_id,
        	person_schedules.title,
        	person_schedules.start_time,
        	person_schedules.end_time,
          person_schedules.room_id,
        	person_schedules.duration,
        	person_schedules.session_assignment_role_type_id,
        	person_schedules.session_assignment_id,
        	person_schedules.session_assignment_name,
        	person_schedules.session_assignment_role_type
        from
        	person_schedules
        left join person_exclusions pe on
        	pe.person_id = person_schedules.person_id
        join exclusions_sessions es on
        	es.exclusion_id = pe.exclusion_id
        left join sessions s on
        	s.id = es.session_id
        where
        	person_schedules.session_id <> s.id
        and (
        	(
        		person_schedules.start_time >= s.start_time
        		and
        		person_schedules.start_time < (s.start_time + (s.duration || ' minute'::text)::interval)
        	)
        	or
        	(
        		person_schedules.end_time > s.start_time
        		and
        		person_schedules.end_time <= (s.start_time + (s.duration || ' minute'::text)::interval)
        	)
        );
      SQL
      ActiveRecord::Base.connection.execute(query)
    end

    def self.create_person_back_to_back_to_back
      # ????
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
            psc1.start_time,
            psc1.end_time,
            psc1.duration as duration,
            psc1.session_assignment_id,
            psc1.session_assignment_role_type_id,
            psc1.session_assignment_name as session_assignment_name,
            psc1.session_assignment_role_type,
            psc1.room_id,
            psc1.id as b2b_id,
            psc2.session_id as middle_session_id,
            psc2.title as middle_title,
            psc2.start_time as middle_start_time,
            psc2.end_time as middle_end_time,
            psc2.duration as middle_duration,
            psc2.session_assignment_id as middle_session_assignment_id,
            psc2.session_assignment_role_type_id as middle_session_assignment_role_type_id,
            psc2.session_assignment_name as middle_session_assignment_name,
            psc2.session_assignment_role_type as middle_session_assignment_role_type,
            psc2.room_id as middle_room_id,
            psc2.conflict_session_id,
            psc2.conflict_session_title,
            psc2.conflict_start_time,
            psc2.conflict_end_time,
            psc2.conflict_duration,
            psc2.conflict_session_assignment_role_type_id,
            psc2.conflict_session_assignment_role_type,
            psc2.conflict_session_assignment_name,
            psc2.conflict_room_id,
            psc2.id as conflict_b2b_id
          from
            person_back_to_back psc1
          inner join person_back_to_back psc2 on
            psc2.session_id = psc1.conflict_session_id
            and psc2.person_id = psc1.person_id
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
            sessions.room_id as session_room_id,
            sessions.duration as session_duration,
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
              duration as session_duration,
              room_id,
              person_id,
              name as person_name,
              published_name as person_published_name,
              session_assignment_id,
              session_assignment_role_type_id,
              session_assignment_name,
              excluded_session_id as conflict_session_id,
              excluded_session_title as conflict_session_title,
              CAST(NULL as timestamp) as conflict_session_start_time,
              CAST(NULL as integer) as conflict_session_duration,
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
            session_duration as session_duration,
            session_room_id as room_id,
            person_id,
            person_name,
            person_published_name,
            session_assignment_id,
            session_assignment_role_type_id,
            session_assignment_name,
            CAST(NULL as uuid) as conflict_session_id,
            NULL as conflict_session_title,
            CAST(NULL as timestamp) as conflict_session_start_time,
            CAST(NULL as integer) as conflict_session_duration,
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
            duration as session_duration,
            room_id,
            CAST(NULL as uuid) as person_id,
            NULL as person_name,
            NULL as person_published_name,
            CAST(NULL as uuid) as session_assignment_id,
            CAST(NULL as uuid) as session_assignment_role_type_id,
            null as session_assignment_name,
            conflicting_session_id as conflict_session_id,
            conflicting_session_title as conflict_session_title,
            conflicting_session_start_time as conflict_session_start_time,
            conflicting_session_duration as conflict_session_duration,
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
            duration as session_duration,
            room_id,
            person_id,
            name as person_name,
            published_name as person_published_name,
            session_assignment_id,
            session_assignment_role_type_id,
            session_assignment_name,
            conflict_session_id,
            conflict_session_title,
            CAST(NULL as timestamp) as conflict_session_start_time,
            CAST(NULL as integer) as conflict_session_duration,
            conflict_session_assignment_role_type_id,
            conflict_session_assignment_name,
            id as conflict_id,
            'person_schedule_conflict' as conflict_type
          from person_schedule_conflicts
          UNION
        select
            session_id,
            title as session_title,
            start_time as session_start_time,
            duration as session_duration,
            room_id,
            person_id,
            name person_name,
            published_name as person_published_name,
            session_assignment_id,
            session_assignment_role_type_id,
            session_assignment_name,
            conflict_session_id,
            conflict_session_title,
            CAST(NULL as timestamp) as conflict_session_start_time,
            CAST(NULL as integer) as conflict_session_duration,
            conflict_session_assignment_role_type_id,
            conflict_session_assignment_name,
            id as conflict_id,
            'person_back_to_back' as conflict_type
          from person_back_to_back
      SQL
      ActiveRecord::Base.connection.execute(query)
    end

    def self.test_registration_sync_matches_type
      query = <<-SQL.squish
        select relkind from pg_catalog.pg_class where relname = 'registration_sync_matches';
      SQL

      res = ActiveRecord::Base.connection.execute(query)
      res.first["relkind"]
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
        DROP VIEW IF EXISTS person_back_to_back;
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

      ActiveRecord::Base.connection.execute <<-SQL
        DROP VIEW IF EXISTS registration_map_people_counts;
      SQL

      ActiveRecord::Base.connection.execute <<-SQL
        DROP VIEW IF EXISTS registration_map_reg_counts;
      SQL

      ActiveRecord::Base.connection.execute <<-SQL
        DROP VIEW IF EXISTS registration_map_counts;
      SQL

      ActiveRecord::Base.connection.execute <<-SQL
        DROP VIEW IF EXISTS filtered_registration_sync_matches;
      SQL

      if self.test_registration_sync_matches_type == 'm'
        ActiveRecord::Base.connection.execute <<-SQL
          DROP materialized VIEW IF EXISTS registration_sync_matches;
        SQL
      else
        ActiveRecord::Base.connection.execute <<-SQL
          DROP VIEW IF EXISTS registration_sync_matches;
        SQL
      end
    end
  end
end
