class RoomsetsController < ResourceController
  SERIALIZER_CLASS = 'RoomsetSerializer'.freeze
  POLICY_CLASS = 'RoomsetsPolicy'.freeze
  POLICY_SCOPE_CLASS = 'RoomsetsPolicy::Scope'.freeze

end
