module ClydeService
  include HTTParty

  class Client
    attr_accessor :access_token

    def initialize(access_token)
      self.access_token = access_token
    end

    def base_url
      'https://worldcon.staxotest.net'
    end

    # My Details
    def my_details
      response = HTTParty.get(
        "#{base_url}/api/v1/me",
        headers: { 'Authorization' => "Bearer #{access_token}" }
      )
      result = JSON.parse(response.body)

      result
    end

    # TODO: add API calls for participaint fetch and lookup
  end

  def self.get_svc(access_token:)
    ClydeService::Client.new(access_token)
  end
end
