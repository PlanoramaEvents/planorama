namespace :chicon do
  desc "Configure airmeet for chicon"
  task configure_airmeet_test: :environment do
    integration = Integration.find_or_create_by({name: :airmeet})
    # this data is for testing. we are going to need the real information for the actual show here at some point.
    # and/or create a ui for it but let's try this first.
    # none of this gets you actual access to the airmeet so it's probably ok to actually check in???
    integration.update!({
      config: {
        airmeet_id: "c8b39650-f33d-11ec-9c8a-2b58688a7745",
        airmeet_host: "gail.terman@chicon.org",
        active: true
      }
    })

    Room.find_by({name: "Airmeet 1"}).update({integrations: {airmeet: {room_host_email: 'gail.terman@chicon.org'}}})
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

  task test_airmeet: :environment do
    puts AirmeetApiService.info
    puts AirmeetApiService.get_session("f1dc078f-f4dc-4a98-973a-8c364036256b")
    puts AirmeetApiService.get_participants
  end
end

