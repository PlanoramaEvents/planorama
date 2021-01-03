class Survey < ApplicationRecord
  # Survey contains a series of groups, groups contain a series of questions
  has_many :survey_groups, dependent: :destroy
  #, :order => 'sort_order asc'

  has_many :survey_responses

  before_destroy :check_for_use, :check_if_public

  # status to move person to if they fill the survey
  enum accept_status: {
    unknown: 'Unknown',
    probable: 'Probable',
    accepted: 'Accepted',
    declined: 'Declined'
  }

  # status to move person to if they decline the survey
  enum decline_status: {
    unknown: 'Unknown',
    probable: 'Probable',
    accepted: 'Accepted',
    declined: 'Declined'
  }

  private

  def check_for_use
    raise 'can not delete a survey that has responses in the system' if survey_responses.any?
  end

  def check_if_public
    raise 'can not delete a survey that is public' if public
  end
end
