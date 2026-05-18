module Members
  module AuthentikService
    include HTTParty

    def self.base_url
      # Ensure that there is no trailing / in the base url
      ::Integration.find_by({name: "authentik"})&.config["base_url"].chomp("/")
    end

    class Client < Members::MemberServices
      attr_accessor :token

      def initialize(token)
        self.token = token
      end

      def last_page(results:)
        results.dig('pagination', 'total_pages')&.to_i || 0
      end

      def data(results:)
        results['results']
      end

      def person(id:)
        url = "/api/v3/core/users/#{id}/"

        response = HTTParty.get(
          "#{Members::AuthentikService.base_url}#{url}",
          headers: {
            'Authorization' => "Bearer #{token}",
            'Accept' => 'application/json'
          }
          # query: { username: id, page_size: 1}
        )

        result = JSON.parse(response.body)

        result
      end


      # 
      #  enables us to page through the members
      # 
      def people_by_page(page: 1, page_size: 20)
        url = "/api/v3/core/users/"
        response = HTTParty.get(
          "#{Members::AuthentikService.base_url}#{url}?page=#{page}&page_size=#{page_size}",
          headers: {
            'Authorization' => "Bearer #{token}",
            'Accept' => 'application/json'
          }
        )
        result = JSON.parse(response.body)

        result
      end

    end

    def self.get_svc(token:)
      Members::AuthentikService::Client.new(token)
    end
  end
end
