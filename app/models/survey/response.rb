class Survey::Response < ApplicationRecord
  belongs_to :survey_question

  belongs_to :survey
  belongs_to :person
end
