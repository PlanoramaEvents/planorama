class Survey::Page < ApplicationRecord
  include RankedModel
  ranks :sort_order, with_same: :survey_id

  nilify_blanks only: [
    :fuuid
  ]

  default_scope { order(['survey_pages.sort_order asc'])}

  has_many :survey_questions,
           class_name: 'Survey::Question',
           foreign_key: 'page_id',
           inverse_of: :page,
           dependent: :destroy
  accepts_nested_attributes_for :survey_questions, allow_destroy: true

  belongs_to :survey

  has_many :survey_answers,
           class_name: 'Survey::Answer',
           foreign_key: 'next_page_id',
           inverse_of: :next_page
  # before delete make site that any answers pointing to this are taken care of

  belongs_to :next_page,
             class_name: 'Survey::Page',
             foreign_key: 'next_page_id',
             optional: true

  has_many :previous_pages,
           class_name: 'Survey::Page',
           foreign_key: 'next_page_id',
           inverse_of: :next_page


  before_destroy :on_delete_next_page_consistency, prepend: true
  before_save :ensure_next_page_consistency

  private

  # Ensure the next page id is a valid value
  def ensure_next_page_consistency
    # next_page is either null, -1 or a valid survey_page_id
    return unless next_page_id #&& next_page_id > 0

    next_page_id = nil unless Survey::Page.exists? next_page_id
  end

  # nil out any next pages that point to the page that is being deleted
  def on_delete_next_page_consistency
    previous_pages.update_all(next_page_id: nil)

    survey_answers.update_all(next_page_id: nil)
  end
end
