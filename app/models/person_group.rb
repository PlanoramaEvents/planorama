class PersonGroup < ApplicationRecord
  belongs_to :person

  enum group: { admin: 'admin', staff: 'staff', participant: 'participant' }
end
