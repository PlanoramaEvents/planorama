class Room < ApplicationRecord
  before_destroy :check_for_use

  include RankedModel
  ranks :sort_order, with_same: :venue_id

  belongs_to :venue

  has_many :programme_items
  has_many :published_programme_items

  def check_for_use
    in_use = (programme_items.any? || published_programme_items.any?)

    if in_use
      raise I18n.t('planner.core.locations.cannot-delete-in-use').html_safe
    end
  end
end
