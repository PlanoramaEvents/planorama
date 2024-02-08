# == Schema Information
#
# Table name: oauth_identities
#
#  id           :uuid             not null, primary key
#  email        :string
#  lock_version :integer
#  provider     :string
#  raw_info     :jsonb            not null
#  reg_number   :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  person_id    :uuid
#  reg_id       :string
#
class OauthIdentitySerializer
  include JSONAPI::Serializer

  attributes :lock_version, :created_at, :updated_at, :id
end
