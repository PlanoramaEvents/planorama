class Survey::Answer < ApplicationRecord
  include RankedModel
  ranks :sort_order, with_same: :survey_question_id

  nilify_blanks only: [
    :fuuid
  ]

  has_paper_trail

  default_scope {order(['survey_answers.sort_order', :answer])}

  # Allows null and -1 ????
  belongs_to :next_page,
             class_name: 'Survey::Page',
             foreign_key: 'next_page_id',
             optional: true

  belongs_to :survey_question,
             class_name: 'Survey::Question',
             foreign_key: 'survey_question_id',
             inverse_of: :survey_answers


  # TODO: on save need to remove next_page refs that do not exist
  before_save :ensure_next_page_consistency

  private

  # Ensure the next page id is a valid value
  def ensure_next_page_consistency
    # next_page is either null, -1 or a valid survey_page_id
    return unless next_page_id > 0

    next_page_id = nil unless Survey::Page.exists? next_page_id
  end
end
