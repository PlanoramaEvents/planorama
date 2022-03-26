class AvailabilitiesController < ResourceController
  SERIALIZER_CLASS = 'AvailabilitySerializer'.freeze
  POLICY_CLASS = 'AvailabilitiesPolicy'.freeze
  POLICY_SCOPE_CLASS = 'AvailabilitiesPolicy::Scope'.freeze

  #
  def belongs_to_param_id
    params[:person_id]
  end

  def belong_to_class
    Person
  end

  def belongs_to_relationship
    'availabilities'
  end

  def allowed_params
    %i[
      lock_version
      id
      start_time
      end_time
      person_id
    ]
  end

  def paginate
    false
  end
end
