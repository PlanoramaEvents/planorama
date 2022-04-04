class Survey::Question < ApplicationRecord
  include RankedModel
  ranks :sort_order, with_same: :page_id

  # Scopes to deal with the soft deletes
  scope :not_deleted, -> { where(deleted_at: nil) }
  scope :deleted, -> { where('survey_questions.deleted_at is not null') }

  has_paper_trail versions: { class_name: 'Audit::SurveyVersion' }, ignore: [:updated_at, :created_at]

  default_scope {includes(:page).order(['survey_pages.sort_order asc', 'survey_questions.sort_order asc'])}

  belongs_to :page,
             class_name: 'Survey::Page',
             foreign_key: 'page_id',
             inverse_of: :questions

  has_one :survey, through: :page

  has_many :answers,
           class_name: 'Survey::Answer',
           foreign_key: 'question_id',
           inverse_of: :question,
           dependent: :destroy
  accepts_nested_attributes_for :answers, :allow_destroy => true

  has_many :responses, dependent: :destroy, class_name: 'Survey::Response', foreign_key: 'question_id'

  validates_inclusion_of :question_type, in:
    [
      :textfield, :textbox, :singlechoice, :multiplechoice, :hr,
      :dropdown, :email, :socialmedia, :textonly,
      :boolean, # true or false
      :yesnomaybe # 'yes', 'no', 'maybe'
      # :address
    ]

  before_destroy :check_for_use, prepend: true #, :check_if_published

  def soft_delete
    if responses.any?
      self.deleted_at = Time.now
      self.save!
    else
      self.destroy
    end
  end

  def question_type
    read_attribute(:question_type).to_sym
  end

  def question_type= (value)
    write_attribute(:question_type, value.to_s)
  end

  def update_answers(new_answers) # A collection of answers that have been passed in
    # If the answer is new then create one and add it (i.e. answer does not have an id)
    # If the answer has an id then update the value
    # Any left over are for deletion
    updates = Hash[ new_answers.map { |a| ( (a[:id] && (a[:id].to_i > 0)) ? [a[:id].to_i, a] : nil) }.compact ]
    newAnswers = new_answers.collect { |a| ( (a[:id] && (a[:id].to_i > 0)) ? nil : a) }.compact

    answers.each do |answer|
      if updates[answer.id]
        answer.update_attributes( updates[answer.id] )
      else
        # delete it and remove it from the collection
        candidate = answers.delete(answer)
      end
    end

    # now create the new ones
    newAnswers.each do |answer|
      answers << SurveyAnswer.new(answer)
    end
  end

  def check_for_use
    # Check if the question has responses
    # TODO: do soft delete ...
    # Survey::Page::QuestionsController#destroy
    if responses.any?
      raise 'can not delete a question for a survey that has responses in the system'
    end
  end

  def check_if_published
    if survey.public
      raise 'can not delete a question for a survey that is public'
    end
  end
end
