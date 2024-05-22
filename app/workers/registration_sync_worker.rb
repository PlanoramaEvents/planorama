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
    PublishedSession.transaction do
      # Phase 1 - get the data from Clyde and store it
      puts "--- Sync Phase 1 #{Time.now}"
      phase1(page_size: 500)
      puts "--- Sync Phase 2 #{Time.now}"
      # Phase 2
      phase2

      # update the status
      status = RegistrationSyncStatus.order('created_at desc').first
      status = RegistrationSyncStatus.new if status == nil
      status.status = 'completed'
      status.save!
    end
    puts "--- Sync Complete #{Time.now}"
  end

  # Phase 1 is to suck up the data from Reg and put it into a temp store
  # for matching
  def phase1(page_size: 500)
    # Get the clyde service and use the AUTH key that we have
    svc = ClydeService.get_svc(token: ENV['CLYDE_AUTH_KEY'])
    if !svc.token
      raise "Missing auth token! abort abort abort!"
    end

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

  # Find good matches and update their information with that from the reg service
  def phase2
    # Find all the people that have an unique match for name AND email
    # (i.e. there is no other match for that registration info)
    matched = Registration::RegistrationMapCount.where(
                  "pid in (?)", Registration::RegistrationMapPeopleCount.where("count = 1").pluck(:pid)
                ).where(
                  "reg_id in (?)", Registration::RegistrationMapRegCount.where("count = 1").pluck(:reg_id)
                ).where("sub_count = 2")

    # Update those people with matched information
    Person.transaction do
      matched.each do |match|
        person = match.person
        # If the person has been mapped to another reg then we ignore it
        next if (person.reg_id && (person.reg_id != match.reg_id))

        datum = RegistrationSyncDatum.find_by reg_id: match.reg_id

        # TODO: update the match status
        # automatic match, assisted match, manual match, no match.
        IdentityService.update_reg_info(person: person, details: datum.raw_info)
      end
    end
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
