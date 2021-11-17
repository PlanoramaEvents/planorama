class Submission::ResponsesController < ResourceController
  MODEL_CLASS = 'Survey::Response'.freeze
  DEFAULT_ORDER = 'id'
  SERIALIZER_CLASS = 'Survey::ResponseSerializer'.freeze

  # TODO: need the survey id etc as a parameter to the collection/index method

  # TODO: do we need this controller
  def belong_to_class
    Survey::Submission
  end

  def belongs_to_relationship
    'responses'
  end

  def belongs_to_param_id
    params[:submission_id]
  end

end
