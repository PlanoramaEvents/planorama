class PersonRole < ApplicationRecord
  belongs_to :person

  # Suffix means we have admin_role, planner_role etc in the code
  enum role: { admin: 'admin', planner: 'planner', member: 'member' }, _suffix: true
end
