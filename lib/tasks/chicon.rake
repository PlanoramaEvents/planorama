namespace :chicon do
  desc "Ensure that the session formats are correct"
  task fix_formats: :environment do
    [
      'Autographing',
      'Ceremony',
      'Concert',
      'Demonstration',
      'Dialog',
      'Discussion',
      'Filk Circle',
      'Game',
      'Game Show',
      'Interview',
      'Meeting',
      'Meetup',
      'Other',
      'Panel',
      'Performance',
      'Presentation',
      'Reading',
      'Rehearsal',
      'Room Turn',
      'Table Talk',
      'Workshop'
    ].each do |format_name|
      Format.create(name: format_name) unless Format.exists?(name: format_name)
    end

    format = Format.find_by name: ""
    if format
      Session.where(format_id: format.id).update_all(format_id: nil)
      format.delete
    end
    format = Format.find_by name: "Edit"
    if format
      Session.where(format_id: format.id).update_all(format_id: nil)
      format.delete
    end

    fix_format("Other (add to notes)", "Other")
    fix_format("Rehersal", "Rehearsal")
    fix_format("Filk", "Filk Circle")
    fix_format("Circle", "Filk Circle")
    fix_format("Room", "Room Turn")
    fix_format("Turn", "Room Turn")
    fix_format("Show", "Game Show")
    fix_format("Table", "Table Talk")
    fix_format("Talk", "Table Talk")
  end

  def fix_format(old_format, new_format)
    format = Format.find_by name: old_format
    new_format = Format.find_by name: new_format
    if format
      Session.where(format_id: format.id).update_all(format_id: new_format.id)
      format.delete
    end
  end

  desc "Map Chicon Exclusions to Session"
  task map_session_to_exclusion: :environment do
    mapping = {
      'Hugo Award Ceremony' => ['Hugo Award Ceremony'],
      'Hugo Award Ceremony rehearsal' => ['Hugo Award Ceremony Rehersal'],
      'Masquerade' => ['Masquerade'],
      'Masquerade rehearsal' => ['Masquerade Rehersal'],
      'Opening Ceremony' => ['Opening Ceremony'],
      'Closing Ceremony' => ['Closing Ceremony'],
      'WSFS Business Meeting' => ['WSFS Buisness Meeting (Friday)', 'WSFS Buisness Meeting (Monday)', 'WSFS Buisness Meeting (Saturday)', 'WSFS Buisness Meeting (Sunday)',],
      'Mark Protection Committee meetings' => ['Mark Protection Committee Meeting'],
      'Joe Siclari and Edie Stern GoH highlight session' => ['Joe Siclari and Edie Stern Session'],
      'Floyd Norman highlight session'=> ['Floyd Norman Session'],
      'Erle Korshak highlight session' => ['Eve L Ewing Session'],
      'Eve L. Ewing highlight session' => ['Gene Ha Session'],
      'Gene Ha highlight session' => ['Eric Wilkerson Session'],
      'Eric Wilkerson highlight session' => ['Remembering Erle Melvin Korshak'],
    }
    # find session, find exclusion

    mapping.each do |ex_text, session_list|
      exclusion = Exclusion.find_by title: ex_text
      if exclusion
        session_list.each do |title|
          session = Session.find_by title: title
          next unless session
          next if exclusion.sessions.include?(session)

          puts "#{ex_text} --> #{session}"
          exclusion.sessions << session
        end
      end
    end
  end

  desc "Seed Chicon Data"
  task seed_exclusions: :environment do
    if Exclusion.count == 0
      Exclusion.create!(
        [
          {
            title: 'Hugo Award Ceremony'
          },
          {
            title: 'Hugo Award Ceremony rehearsal'
          },
          {
            title: 'Masquerade'
          },
          {
            title: 'Masquerade rehearsal'
          },
          {
            title: 'Opening Ceremony'
          },
          {
            title: 'Closing Ceremony'
          },
          {
            title: 'WSFS Business Meeting'
          },
          {
            title: 'Mark Protection Committee meetings'
          },
          {
            title: 'Joe Siclari and Edie Stern GoH highlight session'
          },
          {
            title: 'Floyd Norman highlight session'
          },
          {
            title: 'Erle Korshak highlight session'
          },
          {
            title: 'Eve L. Ewing highlight session'
          },
          {
            title: 'Gene Ha highlight session'
          },
          {
            title: 'Eric Wilkerson highlight session'
          }
        ]
      )
    end
  end

  desc "Seed Chicon Venue/Room Data"
  task seed_rooms: :environment do
    hyatt = Venue.find_by name: "Hyatt Regency Chicago"
    if !hyatt
      Venue.create!(
        [
          {name: "Hyatt Regency Chicago", address: "151 E Wacker Drive, Chicago IL 60601"}
        ]
      )
    end
    airmeet = Venue.find_by name: "Airmeet"
    if !airmeet
      Venue.create!(
        [
          {name: "Airmeet"}
        ]
      )
    end

    hyatt = Venue.find_by name: "Hyatt Regency Chicago"
    if hyatt.rooms.count == 0
      # We only want the rooms that are going to potentially be used for programme
      Room.create!(
        [
          {venue_id: hyatt.id, name: "Plaza AB", floor: "Lobby Level, East Tower", purpose: "Events - Cabaret", comment: "Cabaret Stage", sort_order: 21},
          {venue_id: hyatt.id, name: "Michigan 1", floor: "Concourse Level, East Tower", purpose: "Programming / Stream out", sort_order: 30},
          {venue_id: hyatt.id, name: "Michigan 2", floor: "Concourse Level, East Tower", purpose: "Programming / Stream out", comment: "Academic", sort_order: 31},
          {venue_id: hyatt.id, name: "Michigan 3", floor: "Concourse Level, East Tower", purpose: "Programming / Stream out", sort_order: 32},
          {venue_id: hyatt.id, name: "Michigan Boardroom", floor: "Concourse Level, East Tower", purpose: "Programming", sort_order: 33},
          {venue_id: hyatt.id, name: "Randolph 1", floor: "Concourse Level, East Tower", purpose: "Programming", sort_order: 40},
          {venue_id: hyatt.id, name: "Randolph 2", floor: "Concourse Level, East Tower", purpose: "Programming", sort_order: 41},
          {venue_id: hyatt.id, name: "Randolph 3", floor: "Concourse Level, East Tower", purpose: "Programming", sort_order: 42},
          {venue_id: hyatt.id, name: "Roosevelt 1", floor: "Concourse Level, East Tower", purpose: "Programming", sort_order: 50},
          {venue_id: hyatt.id, name: "Roosevelt 3", floor: "Concourse Level, East Tower", purpose: "Programming", sort_order: 52},
          {venue_id: hyatt.id, name: "Grand Ballroom", floor: "Ballroom Level, East Tower", purpose: "Main Stage", sort_order: 70},
          {venue_id: hyatt.id, name: "Grand Suites 3", floor: "Ballroom Level, East Tower", purpose: "Programming", sort_order: 83},
          {venue_id: hyatt.id, name: "Grand Hall GH", floor: "Ballroom Level, East Tower", purpose: "Events", comment: "Not Saturday all day, Masq Green Room", sort_order: 90},
          {venue_id: hyatt.id, name: "Grand Hall I", floor: "Ballroom Level, East Tower", purpose: "Programming", sort_order: 91},
          {venue_id: hyatt.id, name: "Grand Hall J", floor: "Ballroom Level, East Tower", purpose: "Programming", sort_order: 92},
          {venue_id: hyatt.id, name: "Grand Hall K", floor: "Ballroom Level, East Tower", purpose: "Programming / Events", comment: "Not Sunday afternoon (Hugo Pre-Reception)", sort_order: 93},
          {venue_id: hyatt.id, name: "Grand Hall L", floor: "Ballroom Level, East Tower", purpose: "Programming / Events", comment: "Not Sunday afternoon (Hugo Pre-Reception)", sort_order: 94},
          {venue_id: hyatt.id, name: "Grand Hall MN", floor: "Ballroom Level, East Tower", purpose: "Programming / Events", comment: "Not Sunday afternoon  (Hugo Pre-Reception), Mobie storage before con", sort_order: 95},
          {venue_id: hyatt.id, name: "Burnham", floor: "Third Floor, West Tower", purpose: "Gaming", sort_order: 100},
          {venue_id: hyatt.id, name: "McCormick", floor: "Third Floor, West Tower", purpose: "Programming / Gaming?", sort_order: 101},
          {venue_id: hyatt.id, name: "Field", floor: "Third Floor, West Tower", purpose: "Programming", sort_order: 102},
          {venue_id: hyatt.id, name: "Dusable", floor: "Third Floor, West Tower", purpose: "Programming", sort_order: 103},
          {venue_id: hyatt.id, name: "Horner", floor: "Third Floor, West Tower", purpose: "Gaming", sort_order: 104},
          {venue_id: hyatt.id, name: "Ogden", floor: "Third Floor, West Tower", purpose: "Gaming", sort_order: 105},
          {venue_id: hyatt.id, name: "Wright", floor: "Third Floor, West Tower", purpose: "Programming / Gaming?", sort_order: 106},
          {venue_id: hyatt.id, name: "Addams", floor: "Third Floor, West Tower", purpose: "Programming", comment: "All Glass", sort_order: 107},
          {venue_id: hyatt.id, name: "Crystal Ballroom A", floor: "Lobby Level, West Tower", purpose: "Programming", sort_order: 120},
          {venue_id: hyatt.id, name: "Crystal Ballroom B", floor: "Lobby Level, West Tower", purpose: "Programming / WSFS", comment: "WSFS BM", sort_order: 121},
          {venue_id: hyatt.id, name: "Crystal Ballroom C", floor: "Lobby Level, West Tower", purpose: "Programming", sort_order: 122},
          {venue_id: hyatt.id, name: "Crystal Foyer", floor: "Lobby Level, West Tower", purpose: "Programming / TableTalks", sort_order: 123},
          {venue_id: hyatt.id, name: "Comiskey", floor: "Concourse Level, West Tower", purpose: "Children's Programming", sort_order: 130},
          {venue_id: hyatt.id, name: "Soldier Field", floor: "Concourse Level, West Tower", purpose: "Teen Lounge", sort_order: 136},
          {venue_id: hyatt.id, name: "Wrigley", floor: "Concourse Level, West Tower", purpose: "Programming", comment: "Non traditional program / meetups?", sort_order: 137},
          {venue_id: hyatt.id, name: "Regency Ballroom ABC", floor: "Ballroom Level, West Tower", purpose: "Art Show", sort_order: 140},
          {venue_id: hyatt.id, name: "Regency Ballroom D", floor: "Ballroom Level, West Tower", purpose: "Programming", comment: "Tentative Chesley Awards, Art Show Auction", sort_order: 141},
          {venue_id: hyatt.id, name: "Regency Ballroom North Registration Desk", floor: "Ballroom Level, West Tower", purpose: "Art Demos / Costume Repair", sort_order: 143},
          {venue_id: hyatt.id, name: "Regency Ballroom South Registration Desk", floor: "Ballroom Level, West Tower", purpose: "Art Demos / Costume Repair", sort_order: 144},
          {venue_id: hyatt.id, name: "Atlanta", floor: "Ballroom Level, West Tower", purpose: "Art Show Print Shop Functions? Or Programming?", comment: "90% sure it's programming - need confirmation", sort_order: 145},
          {venue_id: hyatt.id, name: "Other", purpose: "Tours / DH Meetings", sort_order: 171},
          {venue_id: hyatt.id, name: "Autographing", floor: "Riverside Exhibit Hall, East Tower", purpose: "Programming", sort_order: 200}
        ]
      )
    end
    airmeet = Venue.find_by name: "Airmeet"
    if airmeet.rooms.count == 0
      Room.create!(
        [
          {venue_id: airmeet.id, name: "Airmeet 1", floor: "Virtual", purpose: "Programming", sort_order: 501},
          {venue_id: airmeet.id, name: "Airmeet 2", floor: "Virtual", purpose: "Programming", sort_order: 502},
          {venue_id: airmeet.id, name: "Airmeet 3", floor: "Virtual", purpose: "Programming", sort_order: 503},
          {venue_id: airmeet.id, name: "Airmeet 4", floor: "Virtual", purpose: "Programming", sort_order: 504}
          # {venue_id: airmeet.id, name: "Stream 1" },
          # {venue_id: airmeet.id, name: "Stream 2" },
          # {venue_id: airmeet.id, name: "Stream 3" }
        ]
      )
    end
  end
end
