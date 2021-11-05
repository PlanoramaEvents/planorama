class Survey::Page::QuestionsController < ResourceController
  MODEL_CLASS = 'Survey::Question'.freeze
  SERIALIZER_CLASS = 'Survey::QuestionSerializer'.freeze

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

  def allowed_params
    %i[
      lock_version
      id
      title
      question
      question_type
      lock_version
      mandatory
      text_size
      sort_order
      horizontal
      private
      regex
      branching
    ]
  end
  # TODO: on save need to remove pages refs that do not exist
end
