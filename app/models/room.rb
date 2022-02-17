class Room < ApplicationRecord
  before_destroy :check_for_use

  include RankedModel
  ranks :sort_order, with_same: :venue_id

  belongs_to :venue

  has_many :sessions
  has_many :published_sessions

  def check_for_use
    in_use = (sessions.any? || published_sessions.any?)

    if in_use
      raise I18n.t('planner.core.locations.cannot-delete-in-use').html_safe
    end
  end
end
