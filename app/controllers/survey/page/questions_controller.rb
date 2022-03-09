class Survey::Page::QuestionsController < ResourceController
  MODEL_CLASS = 'Survey::Question'.freeze
  SERIALIZER_CLASS = 'Survey::QuestionSerializer'.freeze

  # Need to take into account the soft delete ???

  def includes
    [
      :answers
    ]
  end

  def belongs_to_param_id
    params[:page_id]
  end

  def belong_to_class
    Survey::Page
  end

  def belongs_to_relationship
    'questions'
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
      page
      page_id
      answers_attributes
      sort_order_position
      linked_field
    ]
  end

  def after_save
    @object.update(sort_order_position: _permitted_params(object_name)['sort_order_position']) if _permitted_params(object_name)['sort_order_position'].present?
  end

  def object_destroy_method
    :soft_delete
  end

  # TODO: on save need to remove pages refs that do not exist
end
