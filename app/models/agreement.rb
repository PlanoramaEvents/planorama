class Agreement < ApplicationRecord
  enum target: { member: 'member', staff: 'staff', all: 'all' }, _suffix: true

  has_many  :person_agreements
  has_many  :people, through: :person_agreements
end
