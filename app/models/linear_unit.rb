class LinearUnit < ApplicationRecord
  before_destroy :check_for_use

  has_many :rooms
  validates_presence_of :name

  def check_for_use
    in_use = (rooms.any?)

    if in_use
      raise 'Cannot delete a Linear Unit in use'
    end
  end
end
