module Members
  class MemberServices
    
    def last_page(results:)
      raise Members::ServiceError.new("last_page not implemented")
    end

    def data(results:)
      raise Members::ServiceError.new("data not implemented")
    end

    def participants(page: nil)
      raise Members::ServiceError.new("participants not implemented")
    end

    def people(ids:)
      raise Members::ServiceError.new("people not implemented")
    end

    # Get the person/member given their id in reg
    def person(id:)
      raise Members::ServiceError.new("person not implemented")
    end

    # Get a pageable set of members
    def people_by_page(page: 1, page_size: 20)
      raise Members::ServiceError.new("people_by_page not implemented")
    end

    # Used by OAuth to get details of current user
    def me
      raise Members::ServiceError.new("me not implemented")
    end

    def self.get_member_service(service:, token:)
      case service.downcase
      when 'clyde'
        Members::ClydeService.get_svc(token: token)
      when 'authentik'
        Members::AuthentikService.get_svc(token: token)
      else
        raise Members::ServiceError.new("Unknown member service")
      end
    end
  end
end