class SessionSerializer
  include JSONAPI::Serializer

  attributes :id, :lock_version, :created_at, :updated_at
end
