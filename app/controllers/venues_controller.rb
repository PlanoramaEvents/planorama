class VenuesController < ResourceController
  SERIALIZER_CLASS = 'VenueSerializer'.freeze
  POLICY_CLASS = 'VenuePolicy'.freeze
  POLICY_SCOPE_CLASS = 'VenuePolicy::Scope'.freeze

  # Need to get a list of the rooms
  def serializer_includes
    [
      :rooms
    ]
  end

  def includes
    [
      :rooms
    ]
  end

  def references
    [
      :rooms
    ]
  end

end
