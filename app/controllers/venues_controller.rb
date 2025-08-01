class VenuesController < ResourceController
  SERIALIZER_CLASS = 'VenueSerializer'.freeze
  POLICY_CLASS = 'VenuePolicy'.freeze
  POLICY_SCOPE_CLASS = 'VenuePolicy::Scope'.freeze

  # Need to get a list of the rooms
end
