# == Schema Information
#
# Table name: areas
#
#  id           :uuid             not null, primary key
#  lock_version :integer          default(0)
#  name         :string
#  sort_order   :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_areas_on_name  (name) UNIQUE
#
FactoryBot.define do
  factory :area do
    
  end
end
