class IntegrationsController < ResourceController
  # no view endpoints right now so no serializer needed
  # SERIALIZER_CLASS = 'IntegrationSerializer'.freeze
  POLICY_CLASS = 'IntegrationPolicy'.freeze
end
