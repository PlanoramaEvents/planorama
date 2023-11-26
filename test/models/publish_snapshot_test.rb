# == Schema Information
#
# Table name: publish_snapshots
#
#  id                  :uuid             not null, primary key
#  label               :string
#  snapshot            :jsonb
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  publication_date_id :uuid
#
require "test_helper"

class PublishSnapshotTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
