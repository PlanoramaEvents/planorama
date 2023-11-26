# == Schema Information
#
# Table name: agreements
#
#  id             :uuid             not null, primary key
#  agreement_type :string
#  description    :string(10000)
#  lock_version   :integer          default(0)
#  target         :enum
#  terms          :text
#  title          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  created_by_id  :uuid             not null
#  updated_by_id  :uuid             not null
#
# Indexes
#
#  index_agreements_on_created_by_id  (created_by_id)
#  index_agreements_on_target         (target)
#  index_agreements_on_updated_by_id  (updated_by_id)
#
class AgreementSerializer
  include JSONAPI::Serializer

  attributes :id, :created_at, :updated_at, :lock_version,
             :target, :title, :terms, :agreement_type,
             :description

  belongs_to :created_by, serializer: PersonSerializer

  belongs_to :updated_by, serializer: PersonSerializer

  attribute :sign_by_nbr do |object|
    object.person_agreements.size
  end
end
