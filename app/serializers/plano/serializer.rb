module Plano
  module Serializer
    extend ActiveSupport::Concern

    class_methods do
      def protected_attribute(*attributes_list, &block)
        # Rails.logger.debug("*** ADD ATTR #{attributes_list}")
        proc = Proc.new { |record, params|
          # Rails.logger.debug("*** ADD ATTR #{attributes_list}")
          # Rails.logger.debug("*** P: #{record} => #{params[:domain]}")
          # params => domain and current_person
          # TODO: put in logic to test if the person has access
          # record class, attributes_list, and current_person
          true
        }
        # Rails.logger.debug("*** ADD ATTR #{attributes_list} AND #{proc}")
        # if proc is at the end remove it and add the new one
        new_list = attributes_list + [{if: proc}]
        attributes(*new_list, &block)
      end

      def protected_attributes(*attributes_list, &block)
        attributes_list.each do |attr|
          protected_attribute(attr, &block)
        end
      end
    end
  end
end
