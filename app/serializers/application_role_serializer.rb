class ApplicationRoleSerializer
  include JSONAPI::Serializer

  attributes :id, :created_at, :updated_at, :lock_version,
             :name, :sensitive_access

  attribute :permissions
end
