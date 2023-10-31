# 
# Sync with the registration system.
# 2 Phases
#  1. Get the data from Reg
#  2. Match people where we can
# 
# Database
# Reg id, name, email, json_data

# RegistrationSyncWorker.perform_async
class RegistrationSyncWorker
  include Sidekiq::Worker

  def perform
    # puts "START GET"
    # Phase 1 - get the data from Clyde and store it
    phase1
    # Phase 2
  end

  # Phase 1 is to suck up the data from Reg and put it into a temp store
  # for matching
  def phase1(page_size: 500)
    # puts "PHASE1"
    RegistrationSyncDatum.connection.truncate(RegistrationSyncDatum.table_name)

    # Get the clyde service and use the AUTH key that we have
    svc = ClydeService.get_svc(token: ENV['CLYDE_AUTH_KEY'])

    results = svc.people_by_page(page: 1, page_size: page_size)
    # puts "PAGE: #{results['meta']['current_page']}"
    store_reg_data(data: results['data'])

    last_page = results['meta']['last_page'].to_i
    for page in (2..last_page) do
      results = svc.people_by_page(page: page, page_size: page_size)
      # puts "PAGE: #{results['meta']['current_page']}"
      store_reg_data(data: results['data'])
    end
  end

  def phase2
    # find matches for each of the people
    # We are only interested in people in Plano that do not have
    # registration information (i.e. no registration_number)
  end

  def store_reg_data(data:)
    RegistrationSyncDatum.transaction do
      data.each do |d|
        # puts "#{d['id']} -> #{d['full_name']} -> #{d['email']}"
        # preferred_name, alternative_email
        RegistrationSyncDatum.create(
          reg_id: d['id'],
          name: d['full_name'],
          email: d['email'],
          registration_number: d['ticket_number'],
          preferred_name: d['preferred_name'],
          alternative_email: d['alternative_email']
        )
      end
    end
  end

end
