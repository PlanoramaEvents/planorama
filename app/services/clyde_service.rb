module ClydeService
  include HTTParty

  def self.base_url
    # Ensure that there is no trailing / in the base url
    ::Integration.find_by({name: "clyde"})&.config["base_url"].chomp("/")
  end

  class Client
    attr_accessor :token

    def initialize(token)
      self.token = token
    end

    # NOTE: a search would be useful. Need to ask STAXO about that
    # change per_page
    # svc = ClydeService.get_svc(token: ENV['CLYDE_AUTH_KEY'])
    # svc.participants
    # meta => current_page, from, to, per_page, total
    def participants(page: nil)
      url = "/api/v1/participants?page=#{page}" if page
      url ||= "/api/v1/participants"

      response = HTTParty.get(
        "#{ClydeService.base_url}#{url}",
        headers: { 'Authorization' => "Bearer #{token}" }
      )
      result = JSON.parse(response.body)

      result
    end

    # GET {base_url}/api/v1/participants/{id}
    # svc = ClydeService.get_svc(token: ENV['CLYDE_AUTH_KEY'])
    # svc.participant(id: '918')
    def person(id:)
      response = HTTParty.get(
        "#{ClydeService.base_url}/api/v1/participants/#{id}",
        headers: {
          'Authorization' => "Bearer #{token}",
          'Accept' => 'application/json'
        }
      )
      result = JSON.parse(response.body)

      result
    end

    # 
    #  Get the details of the people with the given set of ids
    # 
    def people(ids:)
      response = HTTParty.get(
        "#{ClydeService.base_url}/api/v1/participants?ids=#{ids.join(',')}",
        headers: {
          'Authorization' => "Bearer #{token}",
          'Accept' => 'application/json'
        }
      )
      result = JSON.parse(response.body)

      result
    end

    # 
    #  enables us to page through the people from Clyde
    # 
    def people_by_page(page: 1, page_size: 20)
      response = HTTParty.get(
        "#{ClydeService.base_url}/api/v1/participants?page=#{page}&page_size=#{page_size}",
        headers: {
          'Authorization' => "Bearer #{token}",
          'Accept' => 'application/json'
        }
      )
      result = JSON.parse(response.body)

      result
    end

    # My Details
    def me
      response = HTTParty.get(
        "#{ClydeService.base_url}/api/v1/me",
        headers: {
          'Authorization' => "Bearer #{token}",
          'Accept' => 'application/json'
        }
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
