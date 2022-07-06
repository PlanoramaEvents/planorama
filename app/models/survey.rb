class Survey < ApplicationRecord
  # Survey contains a series of pages, pages contain a series of questions
  has_many :pages,
           class_name: 'Survey::Page',
           inverse_of: :survey,
           dependent: :destroy
  accepts_nested_attributes_for :pages, allow_destroy: true

  has_paper_trail versions: { class_name: 'Audit::SurveyVersion' }, ignore: [:updated_at, :created_at]

  has_many :questions, through: :pages, class_name: 'Survey::Question'

  has_many :submissions, class_name: 'Survey::Submission', dependent: :destroy

  has_many :mailings
  has_many :mailed_submitters, through: :mailings, source: :person

  before_destroy :check_if_public, :check_for_use
  before_update :check_if_public
  before_save :check_if_public

  belongs_to :published_by, class_name: 'Person', required: false
  belongs_to :created_by, class_name: 'Person', required: false
  belongs_to :updated_by, class_name: 'Person', required: false

  has_and_belongs_to_many :assigned_people, class_name: 'Person'

  nilify_blanks only: [
    :description
  ]

  validates :name, presence: true

  # transition_accept_status
  # transition_decline_status

  # TODO change last modified on survey_questions CUD
  # TODO track created/updated by

  private

  def check_for_use
    # If it has submissions with responses
    raise 'can not delete a survey that has responses in the system' if submissions.joins(:responses).any?
  end

  def check_if_public
    return if self.new_record?

    return if self.public && self.public_changed? # to allow for changing to "published"

    raise 'can not delete or update a survey that is public' if self.public
  end
end
