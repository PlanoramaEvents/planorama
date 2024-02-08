# == Schema Information
#
# Table name: room_sets
#
#  id           :uuid             not null, primary key
#  description  :string
#  lock_version :integer          default(0)
#  name         :string
#  sort_order   :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
FactoryBot.define do
  factory :room_set do
    name { "MyString" }
    description { "MyString" }
    sort_order { 1 }
  end
end
