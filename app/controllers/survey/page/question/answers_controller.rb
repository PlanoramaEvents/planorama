class Survey::Page::Question::AnswersController < ResourceController
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
    'answers'
  end

  # def allowed_params
  #   %i[
  #     lock_version
  #     id
  #     answer
  #     lock_version
  #     default
  #     sort_order
  #     other
  #     next_page_id
  #     next_page_action
  #   ]
  # end
end
