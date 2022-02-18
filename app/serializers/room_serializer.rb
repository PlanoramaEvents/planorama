class RoomSerializer
  include JSONAPI::Serializer

  attributes :id, :lock_version, :created_at, :updated_at,
             :name, :sort_order, :purpose, :capacity
end
