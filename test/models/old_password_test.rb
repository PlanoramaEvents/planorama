# == Schema Information
#
# Table name: old_passwords
#
#  id                       :bigint           not null, primary key
#  encrypted_password       :string           not null
#  password_archivable_type :string           not null
#  password_salt            :string
#  created_at               :datetime
#  password_archivable_id   :integer          not null
#
# Indexes
#
#  index_password_archivable  (password_archivable_type,password_archivable_id)
#
require "test_helper"

class OldPasswordTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
