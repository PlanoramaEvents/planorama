class Survey::Page::AnswersController < ResourceController
  MODEL_CLASS = 'Survey::Answer'.freeze
  SERIALIZER_CLASS = 'Survey::AnswerSerializer'.freeze
  DEFAULT_ORDER = 'sort_order'

  def belongs_to_param_id
    params[:question_id]
  end

  def belong_to_class
    Survey::Question
  end

  def belongs_to_relationship
    'survey_answers'
  end
end
