# == Schema Information
#
# Table name: magic_links
#
#  id           :uuid             not null, primary key
#  expires_at   :datetime         not null
#  lock_version :integer          default(0)
#  token        :string           not null
#  url          :string(10000)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  person_id    :uuid             not null
#
# Indexes
#
#  index_magic_links_on_person_id  (person_id)
#
require 'test_helper'

class MagicLinkTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
