namespace :la_zoom do
  # rake la_zoom:rooms
  desc "Setup integration info for Zoom"
  task rooms: :environment do
    # ids of rooms that are streamed
    webinar_rooms = [
      "7673f8cc-2514-44e3-87c4-0e9e990cd817",
      "9453918d-4cf0-46a9-b755-8113ac851afd",
      "b57b5a2a-9b13-446c-87db-f7ba1f8f59fb",
      "686d09c2-5b29-4c62-b5a1-1a8899f0d193",
      "68310077-5489-4153-a352-23add1c3678a",
      "b89bdd9a-8cc2-4518-b68c-0ea0d1cd1a4d",
      "9262f58e-1a6a-4e46-8124-0b09fb5588ea",
      "aecf9f62-5730-4d2e-b6e2-c3ae4ab6ce72",
      "a3c5939b-5d32-4268-ab85-341882f93889",
      "76e38998-0350-4463-89fb-e41de09f2299",
      "cba3da72-726c-482f-beea-132917f812d0",
      "cf07d6fc-ac66-487b-a1ae-ab8ee8566ec3",
      "1b6defe6-7b4a-47dd-bc26-4f68179930d1",
      "10a9cd9d-14fe-44f1-bb71-5756eadb30ab"
    ]
    # ids of rooms that are for meetings
    # This is a room that is online only
    always_webinar = [
      "7409f799-9434-4cfa-b7ba-c1a9d7fcdff5",
      "b46a0a34-ff35-4351-85f5-cfbd8cffc605",
      "cda6c471-2abf-4f79-8c1c-e917a59624fc",
      "0c1df9dd-fcaa-45af-b1cb-1057ccb23c8b",
      "a2016003-d94b-477a-bb17-6d5aa14ae16a"
    ]
    meeting_rooms = [
      "85325568-8608-4bed-92fe-7ceb33c5d8c4",
      "07254308-9339-43ce-856a-bd8fc305428a"
    ]
    # id of room that is only discord
    discord = [
      "0df786c9-4ff3-470a-b609-114f2a04991b"
    ]

    alternate_host_count = 1

    # Add integrations to session
    # Meeting type is either a zoom meeting type of discord
    # virtual_room true means all sessions in the room will be online regardless of session streaming flag
    # used only for rooms that are zoom (not physical)
    webinar_rooms.each do |id|
      room = Room.find id
      next unless room

      room.integrations["zoom"] = { 
        meeting_type: :webinar,
        virtual_room: false, 
        alternate_host: "zoomhost+#{alternate_host_count}@lacon.org"
      }
      alternate_host_count += 1
      room.save!
    end

    always_webinar.each do |id|
      room = Room.find id
      next unless room

      room.integrations["zoom"] = {
        meeting_type: :webinar,
        virtual_room: true, 
        alternate_host: "zoomhost+#{alternate_host_count}@lacon.org"
      }
      alternate_host_count += 1
      room.save!
    end

    discord.each do |id|
      room = Room.find id
      next unless room

      room.integrations["zoom"] = { meeting_type: :discord }
      room.save!
    end

    meeting_rooms.each do |id|
      room = Room.find id
      next unless room

      room.integrations["zoom"] = {
        meeting_type: :meeting,
        virtual_room: true,
        alternate_host: "zoomhost+#{alternate_host_count}@lacon.org"
      }
      alternate_host_count += 1
      room.save!
    end

  end
end
