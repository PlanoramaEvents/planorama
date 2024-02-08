class CuratedTagSerializer
  include JSONAPI::Serializer

  attributes :name, :id, :context, :lock_version
end