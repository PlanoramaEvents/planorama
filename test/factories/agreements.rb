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
FactoryBot.define do
  factory :agreement do
    
  end
end
