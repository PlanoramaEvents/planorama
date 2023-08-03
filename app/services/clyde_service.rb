module ClydeService
  include HTTParty

  def self.base_url
    ::Integration.find_by({name: "clyde"})&.config["base_url"]
  end

  class Client
    attr_accessor :token

    def initialize(token)
      self.token = token
    end

    # GET {base_url}/api/v1/participants/{id}
    # svc = ClydeService.get_svc(token: ENV['CLYDE_AUTH_KEY'])
    # svc.participant(id: '918')
    def participant(id:)
      response = HTTParty.get(
        "#{ClydeService.base_url}/api/v1/participants/#{id}",
        headers: { 'Authorization' => "Bearer #{token}" }
      )
      result = JSON.parse(response.body)

      result
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
