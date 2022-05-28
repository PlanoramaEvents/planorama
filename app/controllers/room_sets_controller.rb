class RoomSetsController < ResourceController
  SERIALIZER_CLASS = 'RoomSetSerializer'.freeze
  POLICY_CLASS = 'RoomSetsPolicy'.freeze
  POLICY_SCOPE_CLASS = 'RoomSetsPolicy::Scope'.freeze

  def paginate
    false
  end
end
