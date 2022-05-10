class RoomsetSerializer
  include JSONAPI::Serializer

  attributes :id, :created_at, :updated_at,
             :name, :sort_order, :description
end
