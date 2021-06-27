class Survey::Response < ApplicationRecord
  belongs_to :survey_question
  belongs_to :survey_submission, foreign_key: 'survey_submission_id', class_name: 'Survey::Submission'
end
