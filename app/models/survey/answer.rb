class Survey::Answer < ApplicationRecord
  include RankedModel
  ranks :sort_order, with_same: :survey_question_id

  has_paper_trail

  belongs_to :survey_question,
             class_name: 'Survey::Question',
             foreign_key: 'survey_question_id',
             inverse_of: :survey_answers

  # default_scope {order(['survey_answers.sort_order', :id])}
end
