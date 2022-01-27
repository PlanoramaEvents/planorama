class Area < ApplicationRecord
  has_many :session_areas
  has_many :sessions, through: :session_areas
end
