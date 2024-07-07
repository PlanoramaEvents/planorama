# == Schema Information
#
# Table name: survey_pages
#
#  id               :uuid             not null, primary key
#  next_page_action :enum             default("next_page")
#  sort_order       :integer
#  title            :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  next_page_id     :uuid
#  survey_id        :uuid
#
# Indexes
#
#  index_survey_pages_on_next_page_action  (next_page_action)
#  index_survey_pages_on_survey_id         (survey_id)
#
# Foreign Keys
#
#  fk_rails_...  (survey_id => surveys.id)
#
class Survey::Page < ApplicationRecord
  include RankedModel
  include DirtyAssociations
  ranks :sort_order, with_same: :survey_id

  default_scope { order(['survey_pages.sort_order asc'])}

  has_paper_trail versions: { class_name: 'Audit::SurveyVersion' }, ignore: [:updated_at, :created_at, :lock_version, :sort_order]

  # scope the questions so we do not include those that were deleted
  has_many :questions,
           -> { where(deleted_at: nil) },
           class_name: 'Survey::Question',
           foreign_key: 'page_id',
           inverse_of: :page,
           dependent: :destroy,
           after_add: :dirty_associations,
           after_remove: :dirty_associations
  accepts_nested_attributes_for :questions, allow_destroy: true

  belongs_to :survey

  has_many :answers,
           class_name: 'Survey::Answer',
           foreign_key: 'next_page_id',
           inverse_of: :next_page
  # before delete make site that any answers pointing to this are taken care of

  belongs_to :next_page,
             class_name: 'Survey::Page',
             foreign_key: 'next_page_id',
             optional: true

  enum next_page_action: { next_page: 'next_page', submit: 'submit' }

  has_many :previous_pages,
           class_name: 'Survey::Page',
           foreign_key: 'next_page_id',
           inverse_of: :next_page


  before_destroy :on_delete_next_page_consistency, prepend: true
  before_destroy :check_if_published
  before_update :check_if_published
  before_save :check_if_published, :ensure_next_page_consistency

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

    answers.update_all(next_page_id: nil)
  end

  def check_if_published
    if survey.public
      raise 'can not add, update, or delete a page for a survey that is public'
    end
  end
end
