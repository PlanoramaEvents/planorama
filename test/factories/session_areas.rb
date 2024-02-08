# == Schema Information
#
# Table name: session_areas
#
#  id           :uuid             not null, primary key
#  lock_version :integer
#  primary      :boolean
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  area_id      :uuid
#  session_id   :uuid
#
# Indexes
#
#  index_session_areas_on_session_id_and_area_id  (session_id,area_id) UNIQUE
#
FactoryBot.define do
  factory :session_area do
    
  end
end
