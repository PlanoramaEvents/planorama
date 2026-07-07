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
    # get the data from Reg and store it
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
    # Get the reg service and use the AUTH token that we have
    provider = ENV['REGISTRATION_PROVIDER']
    svc = Members::MemberServices.get_member_service(service: provider, token: ENV['REGISTRATION_TOKEN'])
    if !svc.token
      raise "Missing auth token! abort abort abort!"
    end

    Person.transaction do
      RegistrationSyncDatum.connection.truncate(RegistrationSyncDatum.table_name)
      results = svc.people_by_page(page: 1, page_size: page_size)

      store_reg_data(data: svc.data(results: results))

      last_page = svc.last_page(results: results)
      for page in (2..last_page) do
        results = svc.people_by_page(page: page, page_size: page_size)
        if !results["message"]
          store_reg_data(data: svc.data(results: results))
        else
          puts "We had an issue with the Registration Service ... people by page #{page}, #{page_size}, #{last_page}, #{results["message"]}"
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
    adapter = Adapters::MemberAdapter.get_adapter(service: ENV['REGISTRATION_PROVIDER'])
    RegistrationSyncDatum.transaction do
      if data
        data.each do |d|
          adapter.create_datum(data: d)
        end
      else
        puts "There was an error! Data is empty"
      end
    end
  end
end
