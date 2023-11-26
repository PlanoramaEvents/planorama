# == Schema Information
#
# Table name: availabilities
#
#  id           :uuid             not null, primary key
#  end_time     :datetime
#  lock_version :integer
#  start_time   :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  person_id    :uuid
#
require "test_helper"

class AvailabilityTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
