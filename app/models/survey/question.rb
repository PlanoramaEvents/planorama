class Survey::Question < ApplicationRecord
  include RankedModel
  ranks :sort_order

  default_scope {order(['survey_questions.sort_order', :question])}

  belongs_to :survey

  has_many :survey_answers, dependent: :destroy
  # accepts_nested_attributes_for :survey_answers, :allow_destroy => true

  has_many :survey_responses

  validates_inclusion_of :question_type, in:
    [
      :textfield, :textbox, :singlechoice, :multiplechoice,
      :selectionbox, :break
    ]

  before_destroy :check_for_use, :check_if_published

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

    survey_answers.each do |answer|
      if updates[answer.id]
        answer.update_attributes( updates[answer.id] )
      else
        # delete it and remove it from the collection
        candidate = survey_answers.delete(answer)
      end
    end

    # now create the new ones
    newAnswers.each do |answer|
      survey_answers << SurveyAnswer.new(answer)
    end
  end

private
  def check_for_use
    if survey.survey_responses.any?
      raise 'can not delete a question for a survey that has responses in the system'
    end
  end

  def check_if_published
    if survey.public
      raise 'can not delete a question for a survey that is public'
    end
  end
end
