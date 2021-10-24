class Survey::Page::QuestionsController < ResourceController
  MODEL_CLASS = 'Survey::Question'.freeze
  SERIALIZER_CLASS = 'Survey::QuestionSerializer'.freeze
  DEFAULT_ORDER = 'sort_order'

  def serializer_includes
    [
      :survey_answers
    ]
  end

  def includes
    [
      :survey_answers
    ]
  end

  def belongs_to_param_id
    params[:page_id]
  end

  def belong_to_class
    Survey::Page
  end

  def belongs_to_relationship
    'survey_questions'
  end

  # TODO: on save need to remove pages refs that do not exist
end
