class Survey < ApplicationRecord
  # Survey contains a series of pages, pages contain a series of questions
  has_many :survey_pages,
           class_name: 'Survey::Page',
           inverse_of: :survey,
           dependent: :destroy
  accepts_nested_attributes_for :survey_pages, allow_destroy: true

  has_many :survey_questions, through: :survey_pages, class_name: 'Survey::Question'

  has_many :survey_submissions, class_name: 'Survey::Submission'

  has_many :mail_templates
  has_many :mailings, through: :mail_templates
  has_many :mailed_submitters, through: :mailings, source: :person

  before_destroy :check_for_use #, :check_if_public

  belongs_to :published_by, class_name: 'Person', required: false
  belongs_to :created_by, class_name: 'Person', required: false
  belongs_to :updated_by, class_name: 'Person', required: false

  has_and_belongs_to_many :assigned_people, class_name: 'Person'

  nilify_blanks only: [
    :description
  ]

  # transition_accept_status
  # transition_decline_status

  # TODO change last modified on survey_questions CUD
  # TODO track created/updated by

  private

  def check_for_use
    raise 'can not delete a survey that has responses in the system' if survey_submissions.any?
  end

  def check_if_public
    raise 'can not delete a survey that is public' if public
  end
end
