class Survey::PagesController < ResourceController
  MODEL_CLASS = 'Survey::Page'.freeze
  SERIALIZER_CLASS = 'Survey::PageSerializer'.freeze
  DEFAULT_ORDER = 'sort_order'

  def serializer_includes
    [
      :survey_questions,
      :'survey_questions.survey_answers'
    ]
  end

  def includes
    [
      {
        survey_questions: :survey_answers
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
    'survey_pages'
  end

  # TODO: on delete need to clean up any references in branches to this
end
