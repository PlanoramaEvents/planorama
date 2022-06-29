class RoomService < ApplicationRecord
  validates :name, presence: true

  has_and_belongs_to_many :sessions
end
