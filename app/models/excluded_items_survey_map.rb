class ExcludedItemsSurveyMap < ApplicationRecord
  belongs_to :programme_item
  belongs_to :survey_answer
end
