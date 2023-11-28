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
require 'rails_helper'

RSpec.describe Room, "#factories"  do
  context "room factory" do
    it "creates a room" do
      room = create(:room)
      expect(room.name).to include("my room")
      expect(room.purpose).to be_nil
      expect(room.comment).to be_nil
      expect(room.sort_order).to eq 0
      expect(room.capacity).to be_nil
    end
  end

  context "room_with_detail factory" do
    it "creates a room with details" do
      room = create(:room_with_detail)
      expect(room.purpose).to_not be_empty
      expect(room.comment).to_not be_empty
      expect(room.sort_order).to be_an(Integer)
      expect(room.capacity).to be_an(Integer)
    end
  end
end
