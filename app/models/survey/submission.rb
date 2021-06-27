class Survey::Submission < ApplicationRecord
  belongs_to :survey
  belongs_to :person

  has_many :survey_responses, foreign_key: 'survey_submission_id', class_name: 'Survey::Response', dependent: :destroy
  accepts_nested_attributes_for :survey_responses, allow_destroy: true
end
