class Survey < ApplicationRecord
  # Survey contains a series of pages, pages contain a series of questions
  has_many :pages,
           class_name: 'Survey::Page',
           inverse_of: :survey,
           dependent: :destroy
  accepts_nested_attributes_for :pages, allow_destroy: true

  has_many :questions, through: :pages, class_name: 'Survey::Question'

  has_many :submissions, class_name: 'Survey::Submission'

  has_many :mailings
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
    raise 'can not delete a survey that has responses in the system' if submissions.any?
  end

  def check_if_public
    raise 'can not delete a survey that is public' if public
  end
end
