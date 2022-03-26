class AvailabilitySerializer
  include JSONAPI::Serializer

  attributes :id, :lock_version, :created_at, :updated_at,
             :start_time, :end_time, :person_id
end
