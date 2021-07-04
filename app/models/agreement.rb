class Agreement < ApplicationRecord
  enum target: { member: 'member', staff: 'staff', all: 'all' }, _suffix: true

  has_many  :person_agreements
  has_many  :people, through: :person_agreements

  # TODO: take into account the target of the agreement as well

  # Get all agreements that have not been signed by person
  def self.unsigned(person:)
    raise 'Person needed to list agreements' unless person

    left_outer_joins(:person_agreements)
      .where(
        ['person_agreements.person_id != ?', person.id]
      )
  end

  # Get all agreements that have been signed by person
  def self.signed(person:)
    raise 'Person needed to list agreements' unless person

    left_outer_joins(:person_agreements)
      .where(
        ['person_agreements.person_id = ?', person.id]
      )
  end
end
