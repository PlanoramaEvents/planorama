# == Schema Information
#
# Table name: survey_submissions
#
#  id               :uuid             not null, primary key
#  lock_version     :integer          default(0)
#  name             :string
#  submission_state :enum             default("draft")
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  person_id        :uuid             not null
#  survey_id        :uuid             not null
#
# Indexes
#
#  index_survey_submissions_on_person_id         (person_id)
#  index_survey_submissions_on_submission_state  (submission_state)
#  index_survey_submissions_on_survey_id         (survey_id)
#
# Foreign Keys
#
#  fk_rails_...  (person_id => people.id)
#  fk_rails_...  (survey_id => surveys.id)
#
require 'test_helper'

class Survey::SubmissionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
