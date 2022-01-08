class ParameterNamesController < ResourceController
  SERIALIZER_CLASS = 'ParameterNameSerializer'.freeze

  def includes
    [
      :configuration
    ]
  end

  def paginate
    false
  end

  def allowed_params
    %i[
      id
      lock_version
      parameter
      parameter_value
    ]
  end
end
