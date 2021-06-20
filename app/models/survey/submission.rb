class Survey::Submission < ApplicationRecord
  belongs_to :survey
  belongs_to :person

  has_many :survey_responses, class_name: 'Survey::Response'
end
