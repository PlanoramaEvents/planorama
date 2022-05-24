class RoomsController < ResourceController
  SERIALIZER_CLASS = 'RoomSerializer'.freeze
  POLICY_CLASS = 'RoomPolicy'.freeze
  POLICY_SCOPE_CLASS = 'RoomPolicy::Scope'.freeze
  DEFAULT_SORTBY = 'rooms.name'
end
