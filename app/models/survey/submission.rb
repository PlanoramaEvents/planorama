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
class CheckUniqueSubmission < ActiveModel::Validator
  def validate(record)
    count = if record.id
              Survey::Submission.where(
                  "survey_id = ? and person_id = ? and id != ?", 
                  record.survey_id, record.person_id, record.id
                ).count
            else
              Survey::Submission.where(
                  "survey_id = ? and person_id = ?", 
                  record.survey_id, record.person_id
                ).count
            end
    if count > 0 
      record.errors.add(
        :person,
        "This Survey only allows one submission per Person"
      )
    end
  end
end

class Survey::Submission < ApplicationRecord
  belongs_to :survey
  belongs_to :person

  has_many :responses,
           class_name: 'Survey::Response',
           foreign_key: 'submission_id',
           inverse_of: :submission,
           dependent: :destroy
  # accepts_nested_attributes_for :responses, allow_destroy: true

  enum submission_state: { draft: 'draft', submitted: 'submitted' }

  # validates_with CheckUniqueSubmission
end
