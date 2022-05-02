class ModelPermissionSerializer
  include JSONAPI::Serializer

  attributes :lock_version, :created_at, :updated_at,
             :model_name, :actions
end
