class Venue < ApplicationRecord
  include RankedModel
  ranks :sort_order

  has_many :rooms, dependent: :destroy
  validates_presence_of :name
end
