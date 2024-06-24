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

  def clyde
    authorize model_class, policy_class: policy_class

    # different from airmeet because not using an external mechanism to make this config beforehand
    clyde = Integration.find_or_create_by({name: 'clyde'})
    
    clyde.config["type"] ||= "login" if !clyde.config["type"]

    render json: serializer_class.new(clyde,
        {
          include: serializer_includes,
          params: {domain: "#{request.base_url}"}
        }
      ).serializable_hash(),
      content_type: 'application/json'
  end

  def g24rce
    authorize model_class, policy_class: policy_class
    g24rce = Integration.find_or_create_by({name: 'g24rce'})
    
    render json: serializer_class.new(g24rce,
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
