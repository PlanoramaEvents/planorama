class Agreement < ApplicationRecord
  enum target: { member: 'member', staff: 'staff', all: 'all' }, _suffix: true

  has_many  :person_agreements
  has_many  :people, through: :person_agreements

  # TODO: need version and workflow?

  # Get all agreements that have not been signed by person
  def self.unsigned(person:)
    raise 'Person needed to list agreements' unless person

    scoping = Agreement.targets[:staff] if person.staff?
    scoping = Agreement.targets[:member] if person.member? || person.no_role?

    where(
      [
        "agreements.id not in (select agreement_id from person_agreements where person_id = ? and signed = true)",
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
        ['person_agreements.person_id = ? and signed = true', person.id]
      )
  end

  # Get the latest agreements for each target
  # uses a PG window and partition to acheive this
  def self.latest
    agreements = Agreement.arel_table

    window = Arel::Nodes::Window.new.partition(
              agreements[:target],
              agreements[:agreement_type]
            ).order(agreements[:created_at].desc)

    row_number = Arel::Nodes::NamedFunction.new('row_number', [])

    sub = Agreement.select(
      Arel.star,
      row_number.over(window).as('row_number')
    )

    Agreement.where(
      'agreements.id in (:ids)',
      ids:
        Agreement.select('id').from(
          sub
        )
        .where(
          Arel::Nodes::SqlLiteral.new("row_number = 1")
        )
    )
  end
end
