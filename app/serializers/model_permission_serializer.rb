class ModelPermissionSerializer
  include JSONAPI::Serializer

  attributes :lock_version, :created_at, :updated_at,
             :mdl_name, :actions, :application_role_id
end
