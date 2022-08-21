class IntegrationsController < ResourceController
  SERIALIZER_CLASS = 'IntegrationSerializer'.freeze
  POLICY_CLASS = 'IntegrationPolicy'.freeze

  def airmeet
    authorize model_class, policy_class: policy_class

    airmeet = Integration.find_by({name: 'airmeet'})

    render json: serializer_class.new(airmeet,
        {
          include: serializer_includes,
          params: {domain: "#{request.base_url}"}
        }
      ).serializable_hash(),
      content_type: 'application/json'
  end

  def allowed_params 
    %i[
      id
      name
      lock_version
      config
    ]
  end

end
