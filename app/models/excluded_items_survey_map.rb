class ExcludedItemsSurveyMap < ApplicationRecord
  belongs_to :session
  belongs_to :survey_answer
end
