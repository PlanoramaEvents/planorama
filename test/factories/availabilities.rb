# == Schema Information
#
# Table name: availabilities
#
#  id           :uuid             not null, primary key
#  end_time     :datetime
#  lock_version :integer
#  start_time   :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  person_id    :uuid
#
FactoryBot.define do
  factory :availability do
    
  end
end
