class SetupType < ApplicationRecord
  has_many :programme_items
  has_many :rooms

  validates_uniqueness_of :name
  # TODO: Add template for the item here - equipment etc
end
#
# Template for item baed on setup - i.e. equipment, room layout etc.
#
