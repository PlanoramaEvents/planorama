class IntegrationSerializer
  include JSONAPI::Serializer

  attributes :lock_version, :created_at, :updated_at,
    :name, :id

  attribute :config do |integration|
    {airmeet_id: integration.config["airmeet_id"],
      airmeet_host: integration.config["airmeet_host"],
      enabled: integration.config["enabled"]
    }
  end
end
