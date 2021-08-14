class Survey::Answer < ApplicationRecord
  include RankedModel
  ranks :sort_order, with_same: :survey_question_id

  nilify_blanks only: [
    :fuuid
  ]

  has_paper_trail

  default_scope {order(['survey_answers.sort_order', :answer])}

  # Allow null and -1 ????
  # belongs_to :next_page,
  #            class_name: 'Survey::Page',
  #            foreign_key: 'next_page_id',
  #            optional: true

  belongs_to :survey_question,
             class_name: 'Survey::Question',
             foreign_key: 'survey_question_id',
             inverse_of: :survey_answers


  # TODO: on save need to remove next_page refs that do not exist

end
