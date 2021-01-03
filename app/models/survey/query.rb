
class Survey::Query < ApplicationRecord
  # queryPredicates
  has_many :survey_query_predicates, dependent: :destroy

  belongs_to :user
  belongs_to :survey
end
