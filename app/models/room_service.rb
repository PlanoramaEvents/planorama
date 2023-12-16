# == Schema Information
#
# Table name: room_services
#
#  id           :uuid             not null, primary key
#  lock_version :integer
#  name         :string(2000)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class RoomService < ApplicationRecord
  validates :name, presence: true

  has_and_belongs_to_many :sessions
end
