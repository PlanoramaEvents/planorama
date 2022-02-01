class Area < ApplicationRecord
  include RankedModel
  ranks :sort_order

  has_many :session_areas
  has_many :sessions, through: :session_areas
end
