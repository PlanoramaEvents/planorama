class Survey < ApplicationRecord
  has_paper_trail

  # Survey contains a series of groups, groups contain a series of questions
  has_many :survey_questions, dependent: :destroy, class_name: 'Survey::Question'
  accepts_nested_attributes_for :survey_questions, allow_destroy: true
  #, :order => 'sort_order asc'

  has_many :survey_responses

  before_destroy :check_for_use, :check_if_public

  # transition_accept_status
  # transition_decline_status

  # TODO change last modified on survey_questions CUD
  # TODO track created/updated by

  private

  def check_for_use
    raise 'can not delete a survey that has responses in the system' if survey_responses.any?
  end

  def check_if_public
    raise 'can not delete a survey that is public' if public
  end
end
