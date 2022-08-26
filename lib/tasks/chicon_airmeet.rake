namespace :chicon do
  desc "Configure airmeet for chicon"
  task configure_airmeet_test: :environment do
    integration = Integration.find_or_create_by({name: :airmeet})
    # this data is for testing. we are going to need the real information for the actual show here at some point.
    # and/or create a ui for it but let's try this first.
    # none of this gets you actual access to the airmeet so it's probably ok to actually check in???
    integration.update!({
      config: {
        airmeet_id: "ac4b0bc0-1079-11ed-bed5-3112cc3e0b52",
        airmeet_host: "gail.terman@chicon.org",
        active: true
      }
    })

    # Room.find_by({name: "Airmeet 1"}).update({integrations: {airmeet: {room_host_email: 'gail.terman@chicon.org'}}})
  end

  task configure_airmeet: :environment do
    integration = Integration.find_or_create_by({name: :airmeet})
    # this data is for testing. we are going to need the real information for the actual show here at some point.
    # and/or create a ui for it but let's try this first.
    # none of this gets you actual access to the airmeet so it's probably ok to actually check in???
    integration.update!({
      config: {
        airmeet_id: "NOT SET YET",
        airmeet_host: "NOT SET YET",
        active: false
      }
    })
  end

  task sync_airmeet: :environment do
    AirmeetApiService.sync_to_airmeet
  end

  task clear_airmeet: :environment do
    AirmeetApiService.clear_participant_data
    AirmeetApiService.clear_session_data
  end
end

