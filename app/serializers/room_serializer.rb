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
class RoomSerializer
  include JSONAPI::Serializer

  attributes :id, :lock_version, :created_at, :updated_at,
             :name, :sort_order, :purpose, :comment, :capacity, :floor,
             :open_for_schedule, :is_virtual, :area_of_space,
             :length, :width, :height,
             :venue_id, :room_set_id, :integrations


end
