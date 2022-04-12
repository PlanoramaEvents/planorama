class PersonExclusionSerializer
  include JSONAPI::Serializer

  attributes :id, :lock_version, :created_at, :updated_at,
             :person_id, :exclusion_id
end
