class PersonSessionSerializer < PersonSerializer

  has_many :unsigned_agreements, serializer: AgreementSerializer do |person|
    Agreement.latest.unsigned(person: person)
  end

  # TODO: test
  has_many :person_exclusions, serializer: PersonExclusionSerializer

  # has_many :session_limits, serializer:SessionLimitSerializer
          # links: {
          #   self: -> (object, params) {
          #     "#{params[:domain]}/person/#{object.id}"
          #   },
          #   related: -> (object, params) {
          #     "#{params[:domain]}/person/#{object.id}/session_limit"
          #   }
          # }

end
