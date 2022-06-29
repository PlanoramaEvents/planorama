class RoomSet < ApplicationRecord
  before_destroy :check_for_use

  include RankedModel
  ranks :sort_order

  has_many :sessions

  has_many :rooms
  validates_presence_of :name

  def check_for_use
    in_use = (rooms.any?)

    if in_use
      raise 'Cannot delete a Room Set in use'
    end
  end
end
