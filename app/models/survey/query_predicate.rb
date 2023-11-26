# == Schema Information
#
# Table name: survey_query_predicates
#
#  id                 :uuid             not null, primary key
#  lock_version       :integer          default(0)
#  operation          :string
#  value              :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  survey_query_id    :uuid
#  survey_question_id :uuid
#
class Survey::QueryPredicate < ApplicationRecord
  belongs_to :survey_query
  belongs_to :survey_question
end
