class Room < ApplicationRecord
  before_destroy :check_for_use

  include RankedModel
  ranks :sort_order, with_same: :venue_id

  belongs_to :venue, optional: true
  belongs_to :room_set, optional: true

  has_many :sessions
  has_many :published_sessions

  # TODO: need to add start and end availbilty time
  # could do this at the convention level for now for days
  # TODO: need room setups maybe with capacities

  def check_for_use
    in_use = (sessions.any? || published_sessions.any?)

    if in_use
      raise 'Cannot delete a Room in use'
    end
  end
end
