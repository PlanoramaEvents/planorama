class PersonSessionSerializer < PersonSerializer

  has_many :unsigned_agreements, serializer: AgreementSerializer do |person|
    Agreement.latest.unsigned(person: person)
  end

end
