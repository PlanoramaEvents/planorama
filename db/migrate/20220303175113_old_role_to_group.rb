class OldRoleToGroup < ActiveRecord::Migration[6.1]
  # migrate from old roles from 'admin','planner','member'
  def up
    PersonRole.all.each do |pr|
      case pr.role
        when 'admin'
          PersonGroup.create(
            person_id: pr.person_id,
            group: 'admin'
          )
        when 'planner'
          PersonGroup.create(
            person_id: pr.person_id,
            group: 'staff'
          )
        when 'member'
          PersonGroup.create(
            person_id: pr.person_id,
            group: 'participant'
          )
      end
    end
  end

  def down
    PersonGroup.delete_all
  end
end
