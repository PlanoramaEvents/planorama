class RoomSetsController < ResourceController
  SERIALIZER_CLASS = 'RoomSetSerializer'.freeze
  POLICY_CLASS = 'RoomSetPolicy'.freeze
  POLICY_SCOPE_CLASS = 'RoomSetPolicy::Scope'.freeze
end
