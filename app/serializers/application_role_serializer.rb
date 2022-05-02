class ApplicationRoleSerializer
  include JSONAPI::Serializer

  # :lock_version, 
  attributes :id, :created_at, :updated_at, :name

  has_many :model_permissions, serializer: ModelPermissionSerializer
end
