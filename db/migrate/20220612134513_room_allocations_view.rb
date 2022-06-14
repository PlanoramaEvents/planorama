class RoomAllocationsView < ActiveRecord::Migration[6.1]
  def up
    # This will be extended to union the other conflicts
    execute <<-SQL
      CREATE OR REPLACE VIEW room_allocations AS
      select
      	s.room_id,
      	s.start_time,
      	(s.start_time + (s.duration || ' minute')::interval) as end_time,
      	s.id as session_id
      from
      	sessions s
      inner join rooms r on
      	r.id = s.room_id
      	and s.start_time is not null;
    SQL
  end

  def down
    execute <<-SQL
      DROP VIEW IF EXISTS room_allocations;
    SQL
  end
end
