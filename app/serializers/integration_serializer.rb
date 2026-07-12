# == Schema Information
#
# Table name: integrations
#
#  id           :uuid             not null, primary key
#  config       :jsonb            not null
#  lock_version :integer          default(0)
#  name         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class IntegrationSerializer
  include JSONAPI::Serializer

  attributes :lock_version, :created_at, :updated_at,
    :name, :id

  attribute :config do |integration|
    if integration.name === 'airmeet'
      {airmeet_id: integration.config["airmeet_id"],
        airmeet_host: integration.config["airmeet_host"],
        enabled: integration.config["enabled"]
      }
    elsif integration.name === 'g24rce'
      {
        base_portal_url: integration.config["base_portal_url"],
        enabled: integration.config["enabled"],
        ticket_name: integration.config["ticket_name"]
      }
    elsif integration.name === 'zoom'
      {
        enabled: integration.config["enabled"],
        event_id: integration.config["event_id"],
        account_id: integration.config["account_id"],
        client_id: integration.config["client_id"],
        client_secret: integration.config["client_secret"]        
      }
    else
      integration.config
    end
  end
end
