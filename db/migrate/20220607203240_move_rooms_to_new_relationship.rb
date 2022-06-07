class MoveRoomsToNewRelationship < ActiveRecord::Migration[6.1]
  def up
    execute <<-SQL
      insert into rooms_sessions (session_id, room_id)
      select sessions.id as session_id, sessions.room_id from sessions where sessions.room_id is not null;
    SQL
  end
  def down
    execute <<-SQL
      delete from rooms_sessions;
    SQL
  end
end
