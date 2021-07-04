class ConfigurationsController < ResourceController
  SERIALIZER_CLASS = 'ConfigurationSerializer'.freeze

  def paginate
    false
  end

  def index
    authorize model_class, policy_class: policy_class

    pnames = ParameterName.includes(:configuration).all
    @collection = Hash[pnames.collect{ |k| [k.parameter_name, k.configuration]}]

    render json: @collection,
           adapter: :json,
           content_type: 'application/json'
  rescue => ex
    Rails.logger.error ex.message if Rails.env.development?
    Rails.logger.error ex.backtrace.join("\n\t") if Rails.env.development?
    render status: :bad_request, json: {error: ex.message}
  end

  def allowed_params
    %i[
      lock_version
      parameter
      parameter_value
    ]
  end
end
