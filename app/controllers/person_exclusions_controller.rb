class PersonExclusionsController < ApplicationController
  SERIALIZER_CLASS = 'PersonExclusionSerializer'.freeze
  POLICY_CLASS = 'PersonExclusionsPolicy'.freeze
  POLICY_SCOPE_CLASS = 'PersonExclusionsPolicy::Scope'.freeze

  def belongs_to_param_id
    params[:person_id]
  end

  def belong_to_class
    Person
  end

  def belongs_to_relationship
    'person_exclusions'
  end

  def allowed_params
    %i[
      lock_version
      id
      person_id
      exclusion_id
    ]
  end

  def paginate
    false
  end
end
