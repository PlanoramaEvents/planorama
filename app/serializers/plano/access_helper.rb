module Plano
  module AccessHelper
    extend ActiveSupport::Concern

    class_methods do
      def can_access_response?(response, person)
        # if it is my response then I can have access
        return true if response.submission&.person_id == person.id

        if response.question.private
          AccessControlService.allowed_sensitive_access?(person: person)
        elsif response.question.linked_field
          AccessControlService.linked_field_access?(linked_field: response.question.linked_field, person: person)
        else
          true
        end
      end
    end
  end
end
