class OldRoleToConRole < ActiveRecord::Migration[6.1]
  # migrate from old roles from 'admin','planner','member'
  def up
    PersonRole.all.each do |pr|
      case pr.role
        when 'admin'
          ConventionRole.create(
            person_id: pr.person_id,
            role: 'admin'
          )
        when 'planner'
          ConventionRole.create(
            person_id: pr.person_id,
            role: 'staff'
          )
        when 'member'
          ConventionRole.create(
            person_id: pr.person_id,
            role: 'participant'
          )
      end
    end
  end

  def down
    ConventionRole.delete_all
  end
end
