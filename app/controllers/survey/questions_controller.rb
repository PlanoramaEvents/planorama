class Survey::QuestionsController < ResourceController
  MODEL_CLASS = 'Survey::Question'.freeze
  SERIALIZER_CLASS = 'Survey::QuestionSerializer'.freeze

  def includes
    [
      :survey_answers
    ]
  end

  def belongs_to_param_id
    params[:survey_page_id]
  end

  def belong_to_class
    Survey::Page
  end

  def belongs_to_relationship
    'survey_questions'
  end
end
