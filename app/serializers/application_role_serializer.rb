class ApplicationRoleSerializer
  include JSONAPI::Serializer

  attributes :id, :lock_version, :created_at, :updated_at,
             :name

  has_many :action_permissions, serializer: ActionPermissionSerializer
end
