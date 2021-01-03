class Survey::QueryPredicate < ApplicationRecord
  belongs_to :survey_query
  belongs_to :survey_question
end
