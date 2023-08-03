class OauthIdentitySerializer
  include JSONAPI::Serializer

  attributes :lock_version, :created_at, :updated_at, :id
end
