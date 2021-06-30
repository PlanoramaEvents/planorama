class Survey::Page < ApplicationRecord
  include RankedModel
  ranks :sort_order, with_same: :survey_id

  default_scope { order(['survey_pages.sort_order', :title])}

  has_many :survey_questions,
           class_name: 'Survey::Question',
           foreign_key: 'survey_page_id',
           inverse_of: :survey_page,
           dependent: :destroy
  accepts_nested_attributes_for :survey_questions, allow_destroy: true

  belongs_to :survey
end
