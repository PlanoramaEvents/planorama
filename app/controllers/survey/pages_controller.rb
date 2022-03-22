class Survey::PagesController < ResourceController
  MODEL_CLASS = 'Survey::Page'.freeze
  SERIALIZER_CLASS = 'Survey::PageSerializer'.freeze
  DEFAULT_SORTBY = 'sort_order'

  def serializer_includes
    [
      :questions,
      :'questions.answers'
    ]
  end

  def includes
    [
      {
        questions: :answers
      }
    ]
  end

  def belongs_to_param_id
    params[:survey_id]
  end

  def belong_to_class
    Survey
  end

  def belongs_to_relationship
    'pages'
  end

  def allowed_params
    %i[
      lock_version
      id
      title
      next_page_id
      next_page_action
      sort_order
      sort_order_position
      survey_id
      survey
      questions_attributes
    ]
  end

  def after_save
    @object.update(sort_order_position: _permitted_params(model: object_name)['sort_order_position']) if _permitted_params(model: object_name)['sort_order_position'].present?
  end

  # TODO: on delete need to clean up any references in branches to this
end
