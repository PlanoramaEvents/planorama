class VenueSerializer
  include JSONAPI::Serializer

  attributes :id, :lock_version, :created_at, :updated_at,
             :name, :sort_order, :address
end
