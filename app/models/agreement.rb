class Agreement < ApplicationRecord
  enum target: { member: 'member', staff: 'staff', all: 'all' }, _suffix: true

  has_many  :person_agreements
  has_many  :people, through: :person_agreements

  # Get all agreements that have not been signed by person
  def self.unsigned(person:)
    raise 'Person needed to list agreements' unless person

    scoping = Agreement.targets[:staff] if person.staff?
    scoping = Agreement.targets[:member] if person.member? || person.no_role?

    where(
      [
        "agreements.id not in (select agreement_id from person_agreements where person_id = ?)",
        person.id
      ]
    )
    .where(
      ['target in (?)', [scoping, Agreement.targets[:all]]]
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
