class RoomSerializer
  include JSONAPI::Serializer

  attributes :id, :lock_version, :created_at, :updated_at,
             :name, :sort_order, :purpose, :comment, :capacity,
             :open_for_schedule, :is_virtual, :dimensions, :area_of_space
end
