module Adapters
  class MemberAdapter
    def update_datum(data:)
      raise Adapters::Error.new("Update datum datum not implemented")
    end

    def create_datum(data:)
      raise Adapters::Error.new("Create datum not implemented")
    end

    def self.get_adapter(service:)
      case service.downcase
      when 'clyde'
        Adapters::ClydeAdapter.new
      when 'authentik'
        Adapters::AuthentikAdapter.new
      else
        raise Adapters::Error.new("Unknown member adapter")
      end
    end
  end
end