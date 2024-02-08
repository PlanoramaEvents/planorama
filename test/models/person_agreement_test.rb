# == Schema Information
#
# Table name: person_agreements
#
#  id           :uuid             not null, primary key
#  agreed_on    :datetime         not null
#  lock_version :integer          default(0)
#  signed       :boolean          default(FALSE)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  agreement_id :uuid             not null
#  person_id    :uuid             not null
#
# Indexes
#
#  index_person_agreements_on_agreement_id                (agreement_id)
#  index_person_agreements_on_person_id                   (person_id)
#  index_person_agreements_on_person_id_and_agreement_id  (person_id,agreement_id) UNIQUE
#
require 'test_helper'

class PersonAgreementTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
