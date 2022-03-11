class PersonRole < ApplicationRecord
  belongs_to :person

  # Suffix means we have admin_role, planner_role etc in the code
  # division head, area head
  # enum role: { admin: 'admin', planner: 'planner', member: 'member' }, _suffix: true
  #
  # def admin?
  #   admin_role?
  # end
  #
  # def planner?
  #   planner_role?
  # end
  #
  # def staff?
  #   admin_role? || planner_role?
  # end
  #
  # def member?
  #   member_role?
  # end
end
