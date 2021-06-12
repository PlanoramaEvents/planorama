class Survey::QuestionsController < ResourceController
  MODEL_CLASS = 'Survey::Question'.freeze
  SERIALIZER_CLASS = 'Survey::QuestionSerializer'.freeze

  def includes
    [
      :survey_answers
    ]
  end
end
