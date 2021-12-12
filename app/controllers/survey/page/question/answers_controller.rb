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

  def allowed_params
    %i[
      lock_version
      id
      answer
      lock_version
      default
      sort_order
      sort_order_position
      other
      next_page_id
      next_page_action
      question
      question_id
    ]
  end

  def after_save
    @object.update(sort_order_position: _permitted_params(object_name)['sort_order_position']) if _permitted_params(object_name)['sort_order_position'].present?
  end
end
