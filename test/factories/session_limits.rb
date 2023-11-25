# == Schema Information
#
# Table name: session_limits
#
#  id           :uuid             not null, primary key
#  day          :date
#  lock_version :integer
#  max_sessions :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  person_id    :uuid
#
# Indexes
#
#  index_session_limits_on_person_id          (person_id)
#  index_session_limits_on_person_id_and_day  (person_id,day) UNIQUE
#
FactoryBot.define do
  factory :session_limit do
    
  end
end
