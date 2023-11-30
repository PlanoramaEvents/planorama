# == Schema Information
#
# Table name: rooms
#
#  id                :uuid             not null, primary key
#  area_of_space     :decimal(, )
#  capacity          :integer
#  comment           :text
#  floor             :string
#  height            :decimal(, )
#  integrations      :jsonb            not null
#  is_virtual        :boolean          default(FALSE)
#  length            :decimal(, )
#  lock_version      :integer          default(0)
#  name              :string(490)      not null
#  open_for_schedule :boolean          default(TRUE)
#  purpose           :string
#  sort_order        :integer
#  width             :decimal(, )
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  room_set_id       :uuid
#  venue_id          :uuid
#
# Indexes
#
#  index_rooms_on_room_set_id  (room_set_id)
#
# Foreign Keys
#
#  fk_rails_...  (room_set_id => room_sets.id)
#
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
