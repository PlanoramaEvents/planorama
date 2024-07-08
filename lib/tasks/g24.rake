namespace :g24 do
  desc "Setup integration info for RCE rooms"
  task rce_rooms: :environment do
    stage_rooms = [
      "Nevis",
      "Keen",
      "Clyde Auditorium",
      "Lomond Auditorium",
      "Alsh 1",
      "Alsh 2",
      "Carron",
      "Dochart 1",
      "Dochart 2",
      "Meeting Academy M1",
      "Meeting Academy M2/M3",
      "Inspiration",
      "Hall 2",
      "Events with British Sign Language Interpretation"
    ]
    session_rooms = [
      "Blaven",
      "Cruachan"
    ]

    stage_rooms.each do |name|
      room = Room.find_by name: name
      next unless room

      room.integrations["rce"] = { SegmentType: :stage }
      room.save!
    end

    session_rooms.each do |name|
      room = Room.find_by name: name
      next unless room

      room.integrations["rce"] = { SegmentType: :sessions }
      room.save!
    end
  end

  desc "Map Exclusions to Session"
  task map_session_to_exclusion: :environment do
    mapping = {
      'Opening Ceremony' => ['Opening Ceremony'],
      'Closing Ceremony' => ['Closing Ceremony'],
      'Hugo Award Ceremony' => ['2024 Hugo Awards Ceremony'],
      'Hugo Award Reception' => ['Hugo Reception'],
      'Hugo Award Rehearsal' => ['2024 Hugo Awards Ceremony Finalist Rehearsal #1', '2024 Hugo Awards Ceremony Finalist Rehearsal #2', '2024 Hugo Awards Ceremony Speaker Rehearsal'],
      'Masquerade' => ['Masquerade'],
      'Masquerade Rehearsal' => ['Setup & Rehearsal for Masquerade'],
      'Terri Windling’s keynote item' => ['Guest of Honour Interview: Terri Windling'],
      'Claire Brialey and Mark Plummer’s keynote item' => ['Meet our guests of honour Claire and Mark'],
      'Chris Baker (Fangorn) keynote item' => ['Chris Baker Presents His Life as an Artist'],
      'Nnedi Okorafor’s keynote item' => ['Guest of Honour Interview: Nnedi Okorafor'],
      'Ken MacLeod’s keynote item' => ['Guest of Honour Interview: Ken MacLeod'],
      'Catherine Heymans’ keynote item' => ['SG Highlight Item for Catherine Heymans'],
      'Tanya DePass’s keynote item' => ['SG Highlight Item for Tanya de Pass'],
      'Tendai Huchu’s keynote item' => ['Special Guest Interview: Tendai Huchu'],
      'Three Black Halflings podcast' => ['SG Highlight Item for Three Black Halflings'],
      'Morrow’s Isle - Opera' => ["Morrow's Isle - Opera"],
      'Worldcon Philharmonic Orchestra performance' => ['Worldcon Philharmonic Orchestra'],
      'Christopher Priest Memorial' => ['Christopher Priest Memorial'],
      'Deb Geisler Memorial' => ['Deb Geisler Memorial'],
      'WSFS Business Meeting' => ['WSFS Business Meeting - Friday', 'WSFS Business Meeting - Monday', 'WSFS Business Meeting - Saturday', 'WSFS Business Meeting - Sunday'],
      'Schedule only during childcare hours' => [
          'NO CHILDCARE - Fri evening', 'NO CHILDCARE - Fri lunchtime', 'NO CHILDCARE - Mon evening',
          'NO CHILDCARE - Mon lunchtime', 'NO CHILDCARE - Sat evening', 'NO CHILDCARE - Sat lunchtime',
          'NO CHILDCARE - Sun dinnertime', 'NO CHILDCARE - Sun lunchtime', 'NO CHILDCARE - Thu evening',
          'NO CHILDCARE - Thu morning'
        ]
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

  desc "Seed G24 Exclusions"
  task seed_exclusions: :environment do    
    if Exclusion.count == 0
      Exclusion.create!(
        [
          { "title"=>"Opening Ceremony" },
          { "title"=>"Closing Ceremony" },
          { "title"=>"Hugo Award Ceremony" },
          { "title"=>"Hugo Award Reception" },
          { "title"=>"Hugo Award Rehearsal" },
          { "title"=>"Masquerade" },
          { "title"=>"Masquerade Rehearsal" },
          { "title"=>"Terri Windling’s keynote item" },
          { "title"=>"Claire Brialey and Mark Plummer’s keynote item" },
          { "title"=>"Chris Baker (Fangorn) keynote item" },
          { "title"=>"Nnedi Okorafor’s keynote item" },
          { "title"=>"Ken MacLeod’s keynote item" },
          { "title"=>"Catherine Heymans’ keynote item" },
          { "title"=>"Tanya DePass’s keynote item" },
          { "title"=>"Tendai Huchu’s keynote item" },
          { "title"=>"Three Black Halflings podcast" },
          { "title"=>"Morrow’s Isle - Opera" },
          { "title"=>"Worldcon Philharmonic Orchestra performance" },
          { "title"=>"Christopher Priest Memorial" },
          { "title"=>"Deb Geisler Memorial" },
          { "title"=>"WSFS Business Meeting" },
          { "title"=>"Schedule only during childcare hours" }
        ]
      )
    end
  end

  desc "Seed Venue/Room Data"
  task seed_rooms: :environment do
    crowne = Venue.find_by name: "Crowne Plaza"
    if !crowne
      Venue.create!(
        [
          {name: "Crowne Plaza", address: "Congress Rd, Glasgow G3 8QT, United Kingdom"}
        ]
      )
    end
    sec = Venue.find_by name: "Scottish Event Campus (SEC)"
    if !sec
      Venue.create!(
        [
          {name: "Scottish Event Campus (SEC)", address: "Glasgow, Scotland, G3 8YW"}
        ]
      )
    end
    armadillo = Venue.find_by name: "SEC Armadillo"
    if !armadillo
      Venue.create!(
        [
          {name: "SEC Armadillo", address: "Glasgow, Scotland, G3 8YW"}
        ]
      )
    end
    arc = Venue.find_by name: "Glasgow University ARC"
    if !arc
      Venue.create!(
        [
          {name: "Glasgow University ARC", address: "Glasgow University, Glasgow, Scotland"}
        ]
      )
    end
    village = Venue.find_by name: "Village"
    if !village
      Venue.create!(
        [
          {name: "Village", address: "Glasgow, Scotland"}
        ]
      )
    end
    online = Venue.find_by name: "Online"
    if !online
      Venue.create!(
        [
          {name: "Online", address: "Online"}
        ]
      )
    end

    crowne_rooms
    sec_rooms
    armadillo_rooms
    arc_rooms
    village_rooms
    online_rooms
  end

  def online_rooms
    online = Venue.find_by name: "Online"
    candidates = [
      {venue_id: online.id, name: "Nevis", purpose: "Programme room", sort_order: 500},
      {venue_id: online.id, name: "Keen", purpose: "Programme room", sort_order: 505},
      {venue_id: online.id, name: "Blaven", purpose: "Programme room", sort_order: 510},
      {venue_id: online.id, name: "Cruachan", purpose: "Programme room", sort_order: 525}
    ]
    candidates.each do |candidate|
      room = Room.find_by name: candidate[:name]
      next if room

      Room.create!(candidate)
    end
  end

  def village_rooms
    village = Venue.find_by name: "Village"
    candidates = [
      {venue_id: village.id, name: "Inspiration", purpose: "Programme room", sort_order: 400},
      {venue_id: village.id, name: "Motivation", purpose: "Programme room", sort_order: 405}
    ]
    candidates.each do |candidate|
      room = Room.find_by name: candidate[:name]
      next if room

      Room.create!(candidate)
    end
  end

  def arc_rooms
    arc = Venue.find_by name: "Glasgow University ARC"
    candidates = [
      {venue_id: arc.id, name: "ARC Seminar Suite", purpose: "Programme room", sort_order: 300},
      {venue_id: arc.id, name: "ARC Studio Space", purpose: "Programme room", sort_order: 305}
    ]
    candidates.each do |candidate|
      room = Room.find_by name: candidate[:name]
      next if room

      Room.create!(candidate)
    end
  end

  def crowne_rooms
    crowne = Venue.find_by name: "Crowne Plaza"
    candidates = [
        {venue_id: crowne.id, name: "Argyll 2", purpose: "Programme room", sort_order: 200},
        {venue_id: crowne.id, name: "Argyll 3", purpose: "Programme room", sort_order: 205},
        {venue_id: crowne.id, name: "Castle 1", purpose: "Programme room", sort_order: 210},
        {venue_id: crowne.id, name: "Castle 2", purpose: "Programme room", sort_order: 215},
        {venue_id: crowne.id, name: "Castle 3", purpose: "Programme room", sort_order: 220},
        {venue_id: crowne.id, name: "Staffa/Shuna", purpose: "Programme room/Parties", sort_order: 225},
        {venue_id: crowne.id, name: "Barra", purpose: "Programme room/Parties", sort_order: 230},
        {venue_id: crowne.id, name: "Jura", purpose: "Programme room/Parties", sort_order: 235},
        {venue_id: crowne.id, name: "Orkney", purpose: "Filk", sort_order: 240},
        {venue_id: crowne.id, name: "Malin", purpose: "Filk", sort_order: 245},
        {venue_id: crowne.id, name: "Argyll 1", purpose: "Book launches", sort_order: 250},
        {venue_id: crowne.id, name: "Executive Boardroom", purpose: "Book launches", sort_order: 260}
    ]
    candidates.each do |candidate|
      room = Room.find_by name: candidate[:name]
      next if room

      Room.create!(candidate)
    end
  end

  def sec_rooms
    sec = Venue.find_by name: "Scottish Event Campus (SEC)"
    candidates = [
        {venue_id: sec.id, name: "Hall 1", purpose: "Programme during day (either Table Talks or Lecture Theatre style)", sort_order: 110},
        {venue_id: sec.id, name: "Hall 2", purpose: "Events", sort_order: 112},
        {venue_id: sec.id, name: "Events with British Sign Language Interpretation", purpose: "Events", sort_order: 113},        
        {venue_id: sec.id, name: "Hall 4 (Other)", purpose: "Table Talks (+ Stuff for other divisions)", sort_order: 115},
        {venue_id: sec.id, name: "Hall 4 (Table Talks)", purpose: "Table Talks (+ Stuff for other divisions)", sort_order: 116},
        {venue_id: sec.id, name: "Hall 4 (Autographs)", purpose: "Table Talks (+ Stuff for other divisions)", sort_order: 117},
        {venue_id: sec.id, name: "Hall 4 (Meetups)", purpose: "Table Talks (+ Stuff for other divisions)", sort_order: 118},
        {venue_id: sec.id, name: "Lomond Auditorium", purpose: "Events/Large Programme Items", sort_order: 120},
        {venue_id: sec.id, name: "Alsh 1", purpose: "Programme room", sort_order: 125},
        {venue_id: sec.id, name: "Alsh 2", purpose: "Programme room", sort_order: 130},
        {venue_id: sec.id, name: "Boisdale", purpose: "Green Room/Prog Ops", sort_order: 135},
        {venue_id: sec.id, name: "Carron", purpose: "Programme room", sort_order: 140},
        {venue_id: sec.id, name: "Dochart 1", purpose: "Programme room", sort_order: 145},
        {venue_id: sec.id, name: "Dochart 2", purpose: "Green Room / Table Talks / Prog Ops?", sort_order: 150},
        {venue_id: sec.id, name: "Meeting Academy M1", purpose: "Programme room", sort_order: 155},
        {venue_id: sec.id, name: "Meeting Academy M2/M3", purpose: "Programme room", sort_order: 160},
        {venue_id: sec.id, name: "Meeting Academy M4", purpose: "Programme room", sort_order: 165}
    ]
    candidates.each do |candidate|
      room = Room.find_by name: candidate[:name]
      next if room

      Room.create!(candidate)
    end
  end

  def armadillo_rooms
    armadillo = Venue.find_by name: "SEC Armadillo"
    candidates = [
        {venue_id: armadillo.id, name: "Clyde Auditorium", purpose: "Main Stage for Open/Close/Large concerts", sort_order: 1},
        {venue_id: armadillo.id, name: "Forth", purpose: "Programme room", sort_order: 5},
        {venue_id: armadillo.id, name: "Gala", purpose: "Programme room", sort_order: 10},
    ]
    candidates.each do |candidate|
      room = Room.find_by name: candidate[:name]
      next if room

      Room.create!(candidate)
    end
  end
end
