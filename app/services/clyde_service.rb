module ClydeService
  include HTTParty

  def self.base_url
    ::Configuration.find_by(parameter: "clyde_base_url")&.parameter_value
  end

  class Client
    attr_accessor :token

    def initialize(token)
      self.token = token
    end


    # My Details
    def me
      response = HTTParty.get(
        "#{ClydeService.base_url}/api/v1/me",
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
