module Adapters
  class AuthentikAdapter < Adapters::MemberAdapter
    def update_datum(data:)
      datum = RegistrationSyncDatum.find_by reg_id: data['pk']
      if datum
        datum.update(
          name: data['attributes']['worldcon.org/name']&.strip,
          email: data['email']&.strip,
          registration_number: data['attributes']['worldcon.org/reg-id']&.strip,
          badge_name: data['attributes']['worldcon.org/badge-name']&.strip,
          raw_info: data
        )
      end
    end

    def create_datum(data:)
      # ignore the seattle carry over WSFS nominating only
      return if data['attributes']['worldcon.org/membership-type'] == 'seattleCarryOverWSFSMembership'

      # Rails.logger.debug("******* DATA: #{data}")
      # data['attributes']['worldcon.org/membership-type'],
      RegistrationSyncDatum.create(
        reg_id: data['pk'],
        name: data['attributes']['worldcon.org/name']&.strip,
        email: data['email']&.strip,
        registration_number: data['attributes']['worldcon.org/reg-id']&.strip,
        badge_name: data['attributes']['worldcon.org/badge-name']&.strip,
        raw_info: data
      )
    end
  end
end