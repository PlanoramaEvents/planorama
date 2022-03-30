class PersonSessionSerializer < PersonSerializer

  has_many :unsigned_agreements, serializer: AgreementSerializer do |person|
    Agreement.latest.unsigned(person: person)
  end

  # TODO: test
  has_many :person_exclusions, serializer: PersonExclusionSerializer
end
