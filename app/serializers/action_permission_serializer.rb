class ActionPermissionSerializer
  include JSONAPI::Serializer

  attributes :id, :lock_version, :created_at, :updated_at,
             :mdl_name, :action, :allowed
end
