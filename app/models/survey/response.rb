class Survey::Response < ApplicationRecord
  belongs_to :survey_question, class_name: 'Survey::Question', foreign_key: 'survey_question_id'
  belongs_to :survey_submission, foreign_key: 'survey_submission_id', class_name: 'Survey::Submission'
end
