class Survey::Submission < ApplicationRecord
  belongs_to :survey
  belongs_to :person

  has_many :survey_responses,
           class_name: 'Survey::Response',
           foreign_key: 'survey_submission_id',
           inverse_of: :survey_submission,
           dependent: :destroy
  accepts_nested_attributes_for :survey_responses, allow_destroy: true

  nilify_blanks only: [
    :fuuid
  ]
end
