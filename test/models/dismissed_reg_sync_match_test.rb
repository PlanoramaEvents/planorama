# == Schema Information
#
# Table name: dismissed_reg_sync_matches
#
#  id           :uuid             not null, primary key
#  lock_version :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  person_id    :uuid             not null
#  reg_id       :string           not null
#
# Indexes
#
#  idx_person_reg_id                              (person_id,reg_id) UNIQUE
#  index_dismissed_reg_sync_matches_on_person_id  (person_id)
#  index_dismissed_reg_sync_matches_on_reg_id     (reg_id)
#
require "test_helper"

class DismissedRegSyncMatchTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
