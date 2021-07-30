class EmailAddressSerializer < ActiveModel::Serializer
  attributes :email, :id, :isdefault, :lock_version
end
