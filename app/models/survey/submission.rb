class Survey::Submission < ApplicationRecord
  belongs_to :survey
  belongs_to :person

  has_many :responses,
           class_name: 'Survey::Response',
           foreign_key: 'survey_submission_id',
           inverse_of: :survey_submission,
           dependent: :destroy
  accepts_nested_attributes_for :responses, allow_destroy: true
end
