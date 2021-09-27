class EmailAddressSerializer
  include JSONAPI::Serializer

  attributes :email, :id, :isdefault, :lock_version

  belongs_to :person
end
