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
class Area < ApplicationRecord
  include RankedModel
  ranks :sort_order

  has_many :session_areas, inverse_of: :area
  has_many :sessions, through: :session_areas
end
