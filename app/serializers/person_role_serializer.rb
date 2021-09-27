class PersonRoleSerializer
  include JSONAPI::Serializer

  attributes :role, :id

  belongs_to :person
end
