class ConfigurationsController < ResourceController
  SERIALIZER_CLASS = 'ConfigurationSerializer'.freeze

  def paginate
    false
  end

  def allowed_params
    %i[
      lock_version
      parameter
      parameter_value
    ]
  end
end
