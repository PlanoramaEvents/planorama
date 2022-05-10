class ConventionRole < ApplicationRecord
  belongs_to :person

  enum role: { admin: 'admin', staff: 'staff', participant: 'participant' }

  def application_roles
    ApplicationRole.where("con_roles @> ?", "{#{role}}")
  end
end
