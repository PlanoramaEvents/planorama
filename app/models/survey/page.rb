class Survey::Page < ApplicationRecord
  include RankedModel
  ranks :sort_order

  default_scope { order(['survey_pages.sort_order', :title])}

  has_many :survey_questions, dependent: :destroy, class_name: "Survey::Question", foreign_key: "survey_page_id"
  accepts_nested_attributes_for :survey_questions, allow_destroy: true

  belongs_to :survey
end
