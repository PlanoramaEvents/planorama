class RoomSerializer
  include JSONAPI::Serializer

  attributes :id, :lock_version, :created_at, :updated_at,
             :name, :sort_order, :purpose, :comment, :capacity, :floor,
             :open_for_schedule, :is_virtual, :area_of_space,
             :length, :width, :height,
             :venue_id, :room_set_id, :integrations


end
