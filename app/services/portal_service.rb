class PortalService
  include HTTParty

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

  class Client
    # Insert session and zoom details
    # details is an array of arrays (session_id, zoom_id)
    # {itemId: string, title: string, destination: string, handler: string}
    def add_sessions(details:)
      return unless PortalService.portal_enabled
      
      uri = "/api/upsert-sessions"
      url = "#{PortalService.base_url}#{uri}"
      request_time = Time.now

      body = details

      security_header = PortalService.security_header(request_time: request_time, uri: uri, body: body)

      response = HTTParty.post(
        url,
        headers: {
          'Authorization' => "members:1 planorama #{security_header}",
          'X-Members-RequestTime' => request_time.utc.iso8601,
          "Content-Type" => "application/json",
          'Accept' => 'application/json',
        },
        body: body.to_json
      )

      raise "Portal Add Sessions Failed" if response.code != 200

      response
    end

    # remove session details
    # add of the session ids to remove
    def remove_session(session_ids:)
      return unless PortalService.portal_enabled

      uri = "/api/delete-sessions"
      url = "#{PortalService.base_url}#{uri}"
      request_time = Time.now

      body = session_ids

      security_header = PortalService.security_header(request_time: request_time, uri: uri, body: body)

      response = HTTParty.post(
        url,
        headers: {
          'Authorization' => "members:1 planorama #{security_header}",
          'X-Members-RequestTime' => request_time.utc.iso8601,
          "Content-Type" => "application/json",
          'Accept' => 'application/json',
        },
        body: body.to_json
      )

      raise "Portal Remove Sessions Failed" if response.code != 200

      response
    end
  end

  def self.get_svc
    PortalService::Client.new
  end

  private

  # 
  # Encode the Zoom client and secret so we can use
  # to get the access token
  # 
  # request_time = Time.now
  # Authorization: members:1 planorama <SIGNATURE>
  def self.security_header(request_time:, uri:, body:)
    data = "POST\n"
    data += "#{uri}\n"
    # ISO 8601 format 2026-07-10T19:33:00Z
    data += "#{request_time.utc.iso8601}\n"
    # data += "#{Base64.urlsafe_encode64(body.to_json.to_s, padding: false)}"
    data += "#{Base64.strict_encode64(body.to_json.to_s)}"

    secret = PortalService.api_key
    hmac = OpenSSL::HMAC.hexdigest('SHA256', PortalService.api_key, data)

    hmac
  end
end