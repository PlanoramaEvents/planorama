class AgeRestriction < ApplicationRecord
  validates :name, presence: true

  has_one :session
end
