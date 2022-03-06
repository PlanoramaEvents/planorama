class ConventionRole < ApplicationRecord
  belongs_to :person

  enum role: { admin: 'admin', staff: 'staff', participant: 'participant' }
end
