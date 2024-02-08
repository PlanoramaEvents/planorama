class PersonSessionSerializer < PersonSerializer

  has_many :unsigned_agreements, serializer: AgreementSerializer do |person|
    Agreement.latest.unsigned(person: person)
  end

  has_many :person_exclusions, serializer: PersonExclusionSerializer

  has_many :oauth_identities, serializer: OauthIdentitySerializer
end
