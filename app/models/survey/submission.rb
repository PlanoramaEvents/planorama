# If the survey is unique submission then a respondent is only
# allow one submission...
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

  validates_with CheckUniqueSubmission
end
