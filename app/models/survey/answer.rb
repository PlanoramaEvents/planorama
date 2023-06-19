class Survey::Answer < ApplicationRecord
  include RankedModel
  ranks :sort_order, with_same: :question_id

  has_paper_trail versions: { class_name: 'Audit::SurveyVersion' }, ignore: [:updated_at, :created_at, :lock_version, :sort_order]

  enum next_page_action: { next_page: 'next_page', submit: 'submit' }

  default_scope {order(['survey_answers.sort_order', :answer])}

  # Allows null and -1 ????
  belongs_to :next_page,
             class_name: 'Survey::Page',
             foreign_key: 'next_page_id',
             optional: true

  belongs_to :question,
             class_name: 'Survey::Question',
             foreign_key: 'question_id',
             inverse_of: :answers

  before_save :validate_answer, prepend: true
  before_save :check_if_published, :ensure_next_page_consistency
  before_destroy :check_if_published
  before_update :check_if_published

  # need to check that answer type is valid for question
  def validate_answer
    # if the question type is boolean or yesnomaybe then we ensure we have correct answers
    if question.question_type == :boolean
      raise 'invalid answers for Boolean question type' unless ['true', 'false'].include? value
    end
    if question.question_type == :yesnomaybe
      raise 'invalid answers for YewNoMaybe question type' unless ['yes', 'no', 'maybe'].include? value
    end
    if question.question_type == :attendance_type
      raise 'invalid answers for Attendance question type' unless ['in person', 'virtual', 'hybrid'].include? value
    end

    raise 'this question should not have any answer options' unless [:singlechoice, :multiplechoice, :boolean, :yesnomaybe, :attendance_type].include? question.question_type
  end

  private

  # Ensure the next page id is a valid value
  def ensure_next_page_consistency
    # next_page is either null, -1 or a valid survey_page_id
    return unless next_page_id # && next_page_id > 0

    next_page_id = nil unless Survey::Page.exists? next_page_id
  end

  def check_if_published
    if question.survey.public
      raise 'can not update or delete an answer in a survey that is public'
    end
  end
end
