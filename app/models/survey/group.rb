class Survey::Group < ApplicationRecord
  include RankedModel
  ranks :sort_order

  belongs_to  :survey

  # TODO - RAILS4 fix ordering
  has_many :survey_questions, dependent: :destroy #, :order => 'sort_order asc'

  #before_destroy :check_for_use, :check_if_published
private

  def check_for_use
    if survey.survey_responses.any?
      raise "can not delete a group for a survey that has responses in the system"
    end
  end

  def check_if_published
    if survey.public
      raise "can not delete a group for a survey that is public"
    end
  end

end
