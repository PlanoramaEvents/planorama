class Submission::ResponsesController < ResourceController
  MODEL_CLASS = 'Survey::Response'.freeze
  DEFAULT_SORTBY = 'id'
  SERIALIZER_CLASS = 'Survey::ResponseSerializer'.freeze

  POLICY_CLASS = 'Submission::ResponsePolicy'.freeze
  POLICY_SCOPE_CLASS = 'Submission::ResponsePolicy::Scope'.freeze

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
