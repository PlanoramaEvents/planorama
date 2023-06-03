module ClydeService
  include HTTParty

  class Client
    attr_accessor :token

    def initialize(token)
      self.token = token
    end

    def base_url
      # TODO: get this from settings
      'https://worldcon.staxotest.net'
    end

    # My Details
    def me
      response = HTTParty.get(
        "#{base_url}/api/v1/me",
        headers: { 'Authorization' => "Bearer #{token}" }
      )
      result = JSON.parse(response.body)

      result
    end

    # TODO: add API calls for participaint fetch and lookup
  end

  def self.get_svc(token:)
    ClydeService::Client.new(token)
  end
end
