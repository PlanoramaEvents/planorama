class ConfigurationsController < ResourceController
  SERIALIZER_CLASS = 'ConfigurationSerializer'.freeze

  def paginate
    false
  end

  # def index
  #   authorize model_class, policy_class: policy_class
  #
  #   pnames = ParameterName.includes(:configuration).all
  #   @collection = Hash[pnames.collect{ |k| [k.parameter_name, k.configuration]}]
  #
  #   render json: @collection,
  #          adapter: :json,
  #          content_type: 'application/json'
  # end

  def allowed_params
    %i[
      id
      lock_version
      parameter
      parameter_value
      parameter_json
    ]
  end
end
