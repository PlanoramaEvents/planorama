# If survey changed to multiple and there are already saved responses do not allow change
class CheckChangeToMultiple < ActiveModel::Validator
  def validate(record)
    # We need to check if the survey is not unique whether there are submissions
    return unless record.unique_submission

    count = Survey::Submission.where("survey_id = ?", record.id).count

    if count > 0 
      record.errors.add(
        :unique_submission,
        "Survey has submissions: not allowed to switch from multiple to unique"
      )
    end
  end
end

class Survey < ApplicationRecord
  # Survey contains a series of pages, pages contain a series of questions
  has_many :pages,
           class_name: 'Survey::Page',
           inverse_of: :survey,
           dependent: :destroy
  accepts_nested_attributes_for :pages, allow_destroy: true

  has_paper_trail versions: { class_name: 'Audit::SurveyVersion' }, ignore: [:updated_at, :created_at, :lock_version]

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

  # TODO change last modified on survey_questions CUD
  # TODO track created/updated by

  # If survey changed to multiple and there are already saved responses do not allow change
  validates_with CheckChangeToMultiple, on: :update, if: :unique_submission_changed?

  # When survey changed to multiple we need to clear out all the linked questions  
  after_save :check_questions
  
  def check_questions
    return if self.unique_submission
    
    # All questions in a non-unique survey can not be linked
    questions.update_all linked_field: nil
  end

  private

  def check_for_use
    # If it has submissions with responses
    raise 'can not delete a survey that has responses in the system' if submissions.joins(:responses).any?
  end

  def check_if_public
    return if self.new_record?

    return if self.public && self.public_changed? # to allow for changing to "published"
    return if self.public && self.name_changed?
    return if self.public && self.description_changed?

    raise 'can not delete or update a survey that is public' if self.public
  end
end
