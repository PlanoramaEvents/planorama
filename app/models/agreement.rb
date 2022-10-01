class Agreement < ApplicationRecord
  enum target: { none: 'none', participant: 'participant', staff: 'staff', all: 'all' }, _suffix: true

  has_many  :person_agreements
  has_many  :people, through: :person_agreements

  # has_paper_trail

  # Get all agreements that have not been signed by person
  def self.unsigned(person:)
    raise 'Person needed to list agreements' unless person

    scoping = [Agreement.targets[:all]]
    scoping += [Agreement.targets[:staff]] if person.staff? || person.admin?
    scoping += [Agreement.targets[:participant]] if person.participant? || person.no_group?

    where(
      [
        "agreements.id not in (select agreement_id from person_agreements where person_id = ? and signed = true)",
        person.id
      ]
    )
    .where(
      ['target in (?)', scoping.compact]
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
