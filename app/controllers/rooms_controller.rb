class RoomsController < ResourceController
  SERIALIZER_CLASS = 'RoomSerializer'.freeze
  POLICY_CLASS = 'RoomsPolicy'.freeze
  POLICY_SCOPE_CLASS = 'RoomsPolicy::Scope'.freeze

end
