class VenuesController < ResourceController
  SERIALIZER_CLASS = 'VenueSerializer'.freeze
  POLICY_CLASS = 'VenuesPolicy'.freeze
  POLICY_SCOPE_CLASS = 'VenuesPolicy::Scope'.freeze

end
