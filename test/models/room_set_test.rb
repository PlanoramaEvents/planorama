# == Schema Information
#
# Table name: room_sets
#
#  id           :uuid             not null, primary key
#  description  :string
#  lock_version :integer          default(0)
#  name         :string
#  sort_order   :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
require "test_helper"

class RoomSetTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
