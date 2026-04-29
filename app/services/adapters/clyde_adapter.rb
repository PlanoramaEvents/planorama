module Adapters
  class ClydeAdapter < Adapters::MemberAdapter
    def update_datum(data:)
      datum = RegistrationSyncDatum.find_by reg_id: data['id']
      if datum
        datum.update(
            name: data['full_name']&.strip,
            email: data['email']&.strip,
            registration_number: data['ticket_number']&.strip,
            preferred_name: data['preferred_name']&.strip,
            alternative_email: data['alternative_email']&.strip,
            badge_name: data['badge']&.strip,
            raw_info: data
          )
      end
    end

    def create_datum(data:)
      # Exclude people that are not attending
      return unless data['attending_status'] != 'Not Attending'
      # Products to exclude from matching
      return if [
        'Chengdu',
        'Volunteer',
        'Apocryphal',
        'Infant',
        'Installment',
        'Hall Pass',
        'Staff',
      ].include? data['product_list_name']

      RegistrationSyncDatum.create(
        reg_id: data['id'],
        name: data['full_name']&.strip,
        email: data['email']&.strip,
        registration_number: data['ticket_number']&.strip,
        preferred_name: data['preferred_name']&.strip,
        alternative_email: data['alternative_email']&.strip,
        badge_name: data['badge']&.strip,
        raw_info: data
      )
    end
  end
end