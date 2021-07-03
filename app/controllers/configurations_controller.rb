class ConfigurationsController < ResourceController
  SERIALIZER_CLASS = 'ConfigurationSerializer'.freeze
  def allowed_params
    %i[
      parameter
      parameter_value
    ]
  end
end
