class PortalService
  # include HTTParty

  def self.portal_enabled
    ::Integration.find_by({name: "portal"})&.config ? ::Integration.find_by({name: "portal"})&.config["enabled"] : false
  end

  def self.base_url
    return nil unless self.portal_enabled

    url = ::Integration.find_by({name: "portal"})&.config ? ::Integration.find_by({name: "portal"})&.config["base_url"] : nil

    url ? url.chomp("/") : nil
  end

  def self.api_key
    return nil unless self.portal_enabled

    ::Integration.find_by({name: "portal"})&.config ? ::Integration.find_by({name: "portal"})&.config["api_key"] : nil
  end
end