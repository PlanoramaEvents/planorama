module Members
  module AuthentikService
    include HTTParty

    def self.base_url
      # Ensure that there is no trailing / in the base url
      ::Integration.find_by({name: "authentik"})&.config["base_url"].chomp("/")
    end

    class Client < Members::MemberServices
      # export AUTHENTIK_URL=http://localhost:9000
      # export AUTHENTIK_TOKEN=Qf6NuSntI4HP2ixTS5cw1TJXM3HgfLbppTtF4kzsblHgovDZmsUn5uXHvZeU
      attr_accessor :token

      def initialize(token)
        self.token = token
      end

      def person(id:)
        # auth_client = Authentik::Client.new(
        #   host: ENV['AUTHENTIK_URL'],
        #   token: token
        # )
        # attributes_filter = {"worldcon.org/reg-id": id}
        # users = auth_client.core_api.core_users_list(
        #   attributes=attributes_filter, page_size=1
        # )

        # # result
        # users
      end


      # 
      #  enables us to page through the members
      # 
      def people_by_page(page: 1, page_size: 20)
        # response = HTTParty.get(
        #   "#{AuthentikService.base_url}/XXX?page=#{page}&page_size=#{page_size}",
        #   # TODO - Auth mechanism may not be bearer
        #   headers: {
        #     'Authorization' => "Bearer #{token}",
        #     'Accept' => 'application/json'
        #   }
        # )
        # result = JSON.parse(response.body)

        # result
      end

    end

    def self.get_svc(token:)
      AuthentikService::Client.new(token)
    end
  end
end
