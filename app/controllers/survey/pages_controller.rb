class Survey::PagesController < ResourceController
  MODEL_CLASS = 'Survey::Page'.freeze
  # SERIALIZER_CLASS = 'Survey::QuestionSerializer'.freeze

  def includes
    [
      survey_questions: :survey_answers
    ]
  end

  def belongs_to_param_id
    params[:survey_id]
  end

  def belong_to_class
    Survey
  end

  def belongs_to_relationship
    'survey_pages'
  end
end
