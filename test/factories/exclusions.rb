# == Schema Information
#
# Table name: exclusions
#
#  id           :uuid             not null, primary key
#  lock_version :integer
#  title        :string(800)      not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
FactoryBot.define do
  factory :exclusion do
    
  end
end
