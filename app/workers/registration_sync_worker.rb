# 
# Sync with the registration system.
# 2 Phases
#  1. Get the data from Reg
#  2. Match people where we can (unique on email and name)
# 

# RegistrationSyncWorker.perform_async
class RegistrationSyncWorker
  include Sidekiq::Worker

  def perform
    # get the data from Clyde and store it
    puts "--- Sync Load Phase #{Time.now}"
    load_phase(page_size: 500)

    # Refresh the materialized view(s)
    MigrationHelpers::PlanoViews.refresh_registration_sync_matches

    puts "--- Update Phase #{Time.now}"
    number_updated = update_phase
    puts "--- Match Phase #{Time.now}"
    number_matched = matched_phase 

    PublishedSession.transaction do
      # update the status
      status = RegistrationSyncStatus.order('created_at desc').first
      status = RegistrationSyncStatus.new if status == nil

      status.result = {
        updated: number_updated,
        matched: number_matched,
        not_found: Person.where("reg_id is null").count
      }
      status.status = 'completed'
      status.save!
    end
    puts "--- Sync Complete #{Time.now}"
  end

  # Phase 1 is to suck up the data from Reg and put it into a temp store
  # for matching
  def load_phase(page_size: 500)
    # Get the clyde service and use the AUTH key that we have
    svc = ClydeService.get_svc(token: ENV['CLYDE_AUTH_KEY'])
    if !svc.token
      raise "Missing auth token! abort abort abort!"
    end

    Person.transaction do
      RegistrationSyncDatum.connection.truncate(RegistrationSyncDatum.table_name)
      results = svc.people_by_page(page: 1, page_size: page_size)

      store_reg_data(data: results['data'])

      last_page = results.dig('meta', 'last_page')&.to_i || 0
      for page in (2..last_page) do
        results = svc.people_by_page(page: page, page_size: page_size)
        if !results["message"]
          store_reg_data(data: results['data'])
        else
          puts "We had an issue with the Clyde ... people by page #{page}, #{page_size}, #{last_page}, #{results["message"]}"
        end
      end
    end
  end

  def update_phase
    number_updated = 0
    Person.transaction do
      existing = Person.where("reg_id is not null")
      existing.each do |person|
        datum = RegistrationSyncDatum.find_by reg_id: person.reg_id
        
        if datum
          res = IdentityService.update_reg_info(person: person, details: datum.raw_info, reg_match: Person.reg_matches[:automatic])
          number_updated += 1 if res
        end
      end
    end

    number_updated
  end

  # Find good matches and update their information with that from the reg service
  def matched_phase
    # Find all the people that have an unique match for name AND email
    # (i.e. there is no other match for that registration info)
    matched = Registration::RegistrationMapCount.where(
                  "pid in (select pid from registration_map_people_counts where count = 1)"
                ).where(
                  "reg_id in (select reg_id from registration_map_reg_counts where count = 1)"
                ).where(
                  "pid not in (select id from people where reg_id is not null)"
                ).where("sub_count = 2")

    # Update those people with matched information
    number_matched = 0
    matched.each do |match|
      Person.transaction do
        person = match.person

        # If the person has already been mapped then we ignore it
        if person.reg_id.nil?
          datum = RegistrationSyncDatum.find_by reg_id: match.reg_id

          # If we match via the worker it is an "automatic match"
          IdentityService.update_reg_info(person: person, details: datum.raw_info, reg_match: Person.reg_matches[:automatic])
          number_matched += 1
        end
      end
    end

    number_matched
  end

  def store_reg_data(data:)
    RegistrationSyncDatum.transaction do
      if data
        data.each do |d|
          # puts "#{d['id']} -> #{d['full_name']} -> #{d['email']}"
          # preferred_name, alternative_email
          # TODO: move to an adapter when we have to support multiple reg services
          next unless d['attending_status'] != 'Not Attending'
          # Products to exclude from matching
          next if [
            'Chengdu',
            'Volunteer',
            'Apocryphal',
            'Infant',
            'Installment',
            'Hall Pass',
            'Staff',
          ].include? d['product_list_name']

          RegistrationSyncDatum.create(
            reg_id: d['id'],
            name: d['full_name']&.strip,
            email: d['email']&.strip,
            registration_number: d['ticket_number']&.strip,
            preferred_name: d['preferred_name']&.strip,
            alternative_email: d['alternative_email']&.strip,
            badge_name: d['badge']&.strip,
            raw_info: d
          )
        end
      else
        puts "There was an error! Data is empty"
      end
    end
  end
end
