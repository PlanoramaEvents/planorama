#
# p "Start room seeds"
#
# after :venue do
#   after :room_set do
#
#     virtual_roomset = RoomSet.find_by_name('Virtual Room')
#     panel_roomset = RoomSet.find_by_name('Panel')
#     theater_roomset = RoomSet.find_by_name('Theater')
#     virtual_venue = Venue.find_by_name('Airmeet')
#     physical_venue = Venue.find_by_name('Hyatt Regency Chicago')
#
#
#     unless Room.find_by_name('Skyway Foyer')
#       Room.create!(
#         name: 'Skyway Foyer',
#         sort_order: 10,
#         purpose: "TBD",
#         comment: "Depending on secure it is, may be storage for instruments for filk / performers in the Plaza",
#         floor: 'Skyway Level, East Tower',
#         venue_id: physical_venue.id,
#         length: '333',
#         width: '256',
#         height: '108',
#         area_of_space: '507',
#         open_for_schedule: false,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Skyway 260')
#       Room.create!(
#         name: 'Skyway 260',
#         sort_order: 11,
#         purpose: "Staff Chill Zone",
#         floor: 'Skyway Level, East Tower',
#         venue_id: physical_venue.id,
#         length: '279',
#         width: '517',
#         height: '108',
#         area_of_space: '961',
#         capacity: '51',
#         open_for_schedule: false,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Skyway 272')
#       Room.create!(
#         name: 'Skyway 272',
#         sort_order: 12,
#         purpose: "Child Care",
#         floor: 'Skyway Level, East Tower',
#         venue_id: physical_venue.id,
#         length: '279',
#         width: '494',
#         height: '108',
#         area_of_space: '811',
#         capacity: '45',
#         open_for_schedule: false,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Plaza Foyer')
#       Room.create!(
#         name: 'Plaza Foyer',
#         sort_order: 20,
#         purpose: "Queueing / Overflow",
#         floor: 'Lobby Level, East Tower',
#         venue_id: physical_venue.id,
#         length: '413',
#         width: '1383',
#         height: '108',
#         area_of_space: '1925',
#         open_for_schedule: false,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Plaza AB')
#       Room.create!(
#         name: 'Plaza AB',
#         sort_order: 21,
#         purpose: "Events - Cabaret",
#         comment: "Cabaret Stage",
#         floor: 'Lobby Level, East Tower',
#         room_set_id: theater_roomset.id,
#         venue_id: physical_venue.id,
#         length: '1113',
#         width: '345',
#         height: '126',
#         area_of_space: '2652',
#         capacity: '200',
#         open_for_schedule: true,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Michigan 1')
#       Room.create!(
#         name: 'Michigan 1',
#         sort_order: 30,
#         purpose: "Programming / Stream out",
#         floor: 'Concourse Level, East Tower',
#         room_set_id: panel_roomset.id,
#         venue_id: physical_venue.id,
#         length: '400',
#         width: '893',
#         height: '102',
#         area_of_space: '2475',
#         capacity: '270',
#         open_for_schedule: true,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Michigan 2')
#       Room.create!(
#         name: 'Michigan 2',
#         sort_order: 31,
#         purpose: "Programming / Stream out",
#         comment: "Academic",
#         floor: 'Concourse Level, East Tower',
#         room_set_id: panel_roomset.id,
#         venue_id: physical_venue.id,
#         length: '318',
#         width: '468',
#         height: '102',
#         area_of_space: '1033',
#         capacity: '80',
#         open_for_schedule: true,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Michigan 3')
#       Room.create!(
#         name: 'Michigan 3',
#         sort_order: 32,
#         purpose: "Programming / Stream out",
#         floor: 'Concourse Level, East Tower',
#         room_set_id: panel_roomset.id,
#         venue_id: physical_venue.id,
#         length: '497',
#         width: '408',
#         height: '102',
#         area_of_space: '1390',
#         capacity: '90',
#         open_for_schedule: true,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Michigan Boardroom')
#       Room.create!(
#         name: 'Michigan Boardroom',
#         sort_order: 33,
#         purpose: "Programming",
#         floor: 'Concourse Level, East Tower',
#         room_set_id: panel_roomset.id,
#         venue_id: physical_venue.id,
#         length: '312',
#         width: '180',
#         height: '102',
#         area_of_space: '390',
#         open_for_schedule: true,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Randolph 1')
#       Room.create!(
#         name: 'Randolph 1',
#         sort_order: 40,
#         purpose: "Programming",
#         floor: 'Concourse Level, East Tower',
#         room_set_id: panel_roomset.id,
#         venue_id: physical_venue.id,
#         length: '396',
#         width: '552',
#         height: '102',
#         area_of_space: '1767',
#         capacity: '108',
#         open_for_schedule: true,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Randolph 2')
#       Room.create!(
#         name: 'Randolph 2',
#         sort_order: 41,
#         purpose: "Programming",
#         floor: 'Concourse Level, East Tower',
#         room_set_id: panel_roomset.id,
#         venue_id: physical_venue.id,
#         length: '432',
#         width: '321',
#         height: '102',
#         area_of_space: '922',
#         capacity: '60',
#         open_for_schedule: true,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Randolph 3')
#       Room.create!(
#         name: 'Randolph 3',
#         sort_order: 42,
#         purpose: "Programming",
#         floor: 'Concourse Level, East Tower',
#         room_set_id: panel_roomset.id,
#         venue_id: physical_venue.id,
#         length: '504',
#         width: '358',
#         height: '102',
#         area_of_space: '1192',
#         capacity: '84',
#         open_for_schedule: true,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Randolph Boardroom')
#       Room.create!(
#         name: 'Randolph Boardroom',
#         sort_order: 43,
#         purpose: "Chairs Office",
#         floor: 'Concourse Level, East Tower',
#         venue_id: physical_venue.id,
#         length: '276',
#         width: '192',
#         height: '102',
#         area_of_space: '368',
#         open_for_schedule: false,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Roosevelt 1')
#       Room.create!(
#         name: 'Roosevelt 1',
#         sort_order: 50,
#         purpose: "Programming",
#         floor: 'Concourse Level, East Tower',
#         room_set_id: panel_roomset.id,
#         venue_id: physical_venue.id,
#         length: '330',
#         width: '504',
#         height: '102',
#         area_of_space: '1186',
#         capacity: '70',
#         open_for_schedule: true,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Roosevelt 2 Boardroom')
#       Room.create!(
#         name: 'Roosevelt 2 Boardroom',
#         sort_order: 51,
#         purpose: "Promotions / Social Media",
#         floor: 'Concourse Level, East Tower',
#         venue_id: physical_venue.id,
#         length: '300',
#         width: '204',
#         height: '102',
#         area_of_space: '425',
#         open_for_schedule: false,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Roosevelt 3')
#       Room.create!(
#         name: 'Roosevelt 3',
#         sort_order: 52,
#         purpose: "Programming",
#         floor: 'Concourse Level, East Tower',
#         room_set_id: panel_roomset.id,
#         venue_id: physical_venue.id,
#         length: '360',
#         width: '660',
#         height: '102',
#         area_of_space: '1650',
#         capacity: '132',
#         open_for_schedule: true,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Roosevelt Boardroom')
#       Room.create!(
#         name: 'Roosevelt Boardroom',
#         sort_order: 53,
#         purpose: "Publications / Newsletter Office",
#         comment: "lose on Sunday night",
#         floor: 'Concourse Level, East Tower',
#         venue_id: physical_venue.id,
#         length: '204',
#         width: '252',
#         height: '102',
#         area_of_space: '357',
#         open_for_schedule: false,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Monroe 1')
#       Room.create!(
#         name: 'Monroe 1',
#         sort_order: 60,
#         purpose: "Treasury",
#         floor: 'Concourse Level, East Tower',
#         venue_id: physical_venue.id,
#         length: '294',
#         width: '237',
#         height: '102',
#         area_of_space: '400',
#         open_for_schedule: false,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Monroe 2')
#       Room.create!(
#         name: 'Monroe 2',
#         sort_order: 61,
#         purpose: "Con Ops",
#         floor: 'Concourse Level, East Tower',
#         venue_id: physical_venue.id,
#         length: '246',
#         width: '180',
#         height: '102',
#         area_of_space: '307',
#         open_for_schedule: false,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Monroe 3')
#       Room.create!(
#         name: 'Monroe 3',
#         sort_order: 62,
#         purpose: "Code of Conduct / Incidence Report",
#         floor: 'Concourse Level, East Tower',
#         venue_id: physical_venue.id,
#         length: '294',
#         width: '180',
#         height: '102',
#         area_of_space: '367',
#         open_for_schedule: false,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Monroe 4')
#       Room.create!(
#         name: 'Monroe 4',
#         sort_order: 63,
#         purpose: "On Site Signage",
#         floor: 'Concourse Level, East Tower',
#         venue_id: physical_venue.id,
#         length: '216',
#         width: '270',
#         height: '102',
#         area_of_space: '405',
#         open_for_schedule: false,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Monroe 5')
#       Room.create!(
#         name: 'Monroe 5',
#         sort_order: 64,
#         purpose: "Con Office",
#         floor: 'Concourse Level, East Tower',
#         venue_id: physical_venue.id,
#         length: '192',
#         width: '252',
#         height: '102',
#         area_of_space: '336',
#         open_for_schedule: false,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Grand Ballroom')
#       Room.create!(
#         name: 'Grand Ballroom',
#         sort_order: 70,
#         purpose: "Main Stage",
#         floor: 'Ballroom Level, East Tower',
#         room_set_id: theater_roomset.id,
#         venue_id: physical_venue.id,
#         length: '2556',
#         width: '1368',
#         height: '204',
#         area_of_space: '24282',
#         capacity: '2400',
#         open_for_schedule: true,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Grand Ballroom North Storage')
#       Room.create!(
#         name: 'Grand Ballroom North Storage',
#         sort_order: 71,
#         purpose: "Reserved Storage WSFS",
#         floor: 'Ballroom Level, East Tower',
#         venue_id: physical_venue.id,
#         open_for_schedule: false,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Grand Ballroom South Storage')
#       Room.create!(
#         name: 'Grand Ballroom South Storage',
#         sort_order: 72,
#         purpose: "Sales to Members",
#         floor: 'Ballroom Level, East Tower',
#         venue_id: physical_venue.id,
#         open_for_schedule: false,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Grand Ballroom Group Office')
#       Room.create!(
#         name: 'Grand Ballroom Group Office',
#         sort_order: 73,
#         purpose: "Sales to Members",
#         floor: 'Ballroom Level, East Tower',
#         venue_id: physical_venue.id,
#         open_for_schedule: false,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Grand Ballroom Registration North')
#       Room.create!(
#         name: 'Grand Ballroom Registration North',
#         sort_order: 74,
#         purpose: "Registration",
#         floor: 'Ballroom Level, East Tower',
#         venue_id: physical_venue.id,
#         open_for_schedule: false,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Grand Ballroom Registration South')
#       Room.create!(
#         name: 'Grand Ballroom Registration South',
#         sort_order: 75,
#         purpose: "Registration",
#         floor: 'Ballroom Level, East Tower',
#         venue_id: physical_venue.id,
#         open_for_schedule: false,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Grand Ballroom Registration Office A')
#       Room.create!(
#         name: 'Grand Ballroom Registration Office A',
#         sort_order: 76,
#         purpose: "Registration Storage",
#         floor: 'Ballroom Level, East Tower',
#         venue_id: physical_venue.id,
#         open_for_schedule: false,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Grand Ballroom Registration Office B')
#       Room.create!(
#         name: 'Grand Ballroom Registration Office B',
#         sort_order: 77,
#         purpose: "Registration Storage",
#         floor: 'Ballroom Level, East Tower',
#         venue_id: physical_venue.id,
#         open_for_schedule: false,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Grand Suites Coatroom')
#       Room.create!(
#         name: 'Grand Suites Coatroom',
#         sort_order: 80,
#         purpose: "Press Check-In",
#         floor: 'Ballroom Level, East Tower',
#         venue_id: physical_venue.id,
#         open_for_schedule: false,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Grand Suites 1')
#       Room.create!(
#         name: 'Grand Suites 1',
#         sort_order: 81,
#         purpose: "Interview / Broadcast Room",
#         floor: 'Ballroom Level, East Tower',
#         venue_id: physical_venue.id,
#         length: '168',
#         width: '228',
#         height: '132',
#         area_of_space: '264',
#         capacity: '16',
#         open_for_schedule: false,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Grand Suites 2')
#       Room.create!(
#         name: 'Grand Suites 2',
#         sort_order: 82,
#         purpose: "Events Lounge",
#         floor: 'Ballroom Level, East Tower',
#         venue_id: physical_venue.id,
#         length: '509',
#         width: '249',
#         height: '132',
#         area_of_space: '764',
#         capacity: '60',
#         open_for_schedule: false,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Grand Suites 3')
#       Room.create!(
#         name: 'Grand Suites 3',
#         sort_order: 83,
#         purpose: "Programming",
#         floor: 'Ballroom Level, East Tower',
#         room_set_id: panel_roomset.id,
#         venue_id: physical_venue.id,
#         length: '300',
#         width: '684',
#         height: '108',
#         area_of_space: '1425',
#         capacity: '120',
#         open_for_schedule: true,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Grand Suites 4')
#       Room.create!(
#         name: 'Grand Suites 4',
#         sort_order: 84,
#         purpose: "Events Office",
#         floor: 'Ballroom Level, East Tower',
#         venue_id: physical_venue.id,
#         length: '168',
#         width: '276',
#         height: '108',
#         area_of_space: '322',
#         open_for_schedule: false,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Grand Suites 5')
#       Room.create!(
#         name: 'Grand Suites 5',
#         sort_order: 85,
#         purpose: "Tech / IT Office",
#         floor: 'Ballroom Level, East Tower',
#         venue_id: physical_venue.id,
#         length: '276',
#         width: '588',
#         height: '132',
#         area_of_space: '1127',
#         capacity: '96',
#         open_for_schedule: false,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Grand Hall GH')
#       Room.create!(
#         name: 'Grand Hall GH',
#         sort_order: 90,
#         purpose: "Events",
#         comment: "Not Saturday all day, Masq Green Room",
#         floor: 'Ballroom Level, East Tower',
#         room_set_id: panel_roomset.id,
#         venue_id: physical_venue.id,
#         length: '920',
#         width: '414',
#         height: '114',
#         area_of_space: '2551',
#         capacity: '210',
#         open_for_schedule: true,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Grand Hall I')
#       Room.create!(
#         name: 'Grand Hall I',
#         sort_order: 91,
#         purpose: "Programming",
#         floor: 'Ballroom Level, East Tower',
#         room_set_id: panel_roomset.id,
#         venue_id: physical_venue.id,
#         length: '920',
#         width: '443',
#         height: '114',
#         area_of_space: '2798',
#         capacity: '225',
#         open_for_schedule: true,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Grand Hall J')
#       Room.create!(
#         name: 'Grand Hall J',
#         sort_order: 92,
#         purpose: "Programming",
#         floor: 'Ballroom Level, East Tower',
#         room_set_id: panel_roomset.id,
#         venue_id: physical_venue.id,
#         length: '920',
#         width: '443',
#         height: '114',
#         area_of_space: '2873',
#         capacity: '225',
#         open_for_schedule: true,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Grand Hall K')
#       Room.create!(
#         name: 'Grand Hall K',
#         sort_order: 93,
#         purpose: "Programming / Events",
#         comment: "Not Sunday afternoon (Hugo Pre-Reception)",
#         floor: 'Ballroom Level, East Tower',
#         room_set_id: panel_roomset.id,
#         venue_id: physical_venue.id,
#         length: '723',
#         width: '451',
#         height: '114',
#         area_of_space: '2310',
#         capacity: '180',
#         open_for_schedule: true,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Grand Hall L')
#       Room.create!(
#         name: 'Grand Hall L',
#         sort_order: 94,
#         purpose: "Programming / Events",
#         comment: "Not Sunday afternoon (Hugo Pre-Reception)",
#         floor: 'Ballroom Level, East Tower',
#         room_set_id: panel_roomset.id,
#         venue_id: physical_venue.id,
#         length: '723',
#         width: '451',
#         height: '114',
#         area_of_space: '2243',
#         capacity: '180',
#         open_for_schedule: true,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Grand Hall MN')
#       Room.create!(
#         name: 'Grand Hall MN',
#         sort_order: 95,
#         purpose: "Programming / Events",
#         comment: "Not Sunday afternoon  (Hugo Pre-Reception), Mobie storage before con",
#         floor: 'Ballroom Level, East Tower',
#         room_set_id: panel_roomset.id,
#         venue_id: physical_venue.id,
#         length: '723',
#         width: '451',
#         height: '114',
#         area_of_space: '1951',
#         capacity: '180',
#         open_for_schedule: true,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Burnham')
#       Room.create!(
#         name: 'Burnham',
#         sort_order: 100,
#         purpose: "Gaming",
#         floor: 'Third Floor, West Tower',
#         room_set_id: panel_roomset.id,
#         venue_id: physical_venue.id,
#         length: '305',
#         width: '288',
#         height: '120',
#         area_of_space: '688',
#         capacity: '50',
#         open_for_schedule: true,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('McCormick')
#       Room.create!(
#         name: 'McCormick',
#         sort_order: 101,
#         purpose: "Programming / Gaming?",
#         floor: 'Third Floor, West Tower',
#         room_set_id: panel_roomset.id,
#         venue_id: physical_venue.id,
#         length: '305',
#         width: '315',
#         height: '108',
#         area_of_space: '688',
#         capacity: '50',
#         open_for_schedule: true,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Field')
#       Room.create!(
#         name: 'Field',
#         sort_order: 102,
#         purpose: "Programming",
#         floor: 'Third Floor, West Tower',
#         room_set_id: panel_roomset.id,
#         venue_id: physical_venue.id,
#         length: '305',
#         width: '315',
#         height: '108',
#         area_of_space: '688',
#         capacity: '50',
#         open_for_schedule: true,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Dusable')
#       Room.create!(
#         name: 'Dusable',
#         sort_order: 103,
#         purpose: "Programming",
#         floor: 'Third Floor, West Tower',
#         room_set_id: panel_roomset.id,
#         venue_id: physical_venue.id,
#         length: '317',
#         width: '319',
#         height: '108',
#         area_of_space: '677',
#         capacity: '50',
#         open_for_schedule: true,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Horner')
#       Room.create!(
#         name: 'Horner',
#         sort_order: 104,
#         purpose: "Gaming",
#         floor: 'Third Floor, West Tower',
#         room_set_id: panel_roomset.id,
#         venue_id: physical_venue.id,
#         length: '284',
#         width: '315',
#         height: '108',
#         area_of_space: '628',
#         capacity: '40',
#         open_for_schedule: true,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Ogden')
#       Room.create!(
#         name: 'Ogden',
#         sort_order: 105,
#         purpose: "Gaming",
#         floor: 'Third Floor, West Tower',
#         room_set_id: panel_roomset.id,
#         venue_id: physical_venue.id,
#         length: '284',
#         width: '315',
#         height: '108',
#         area_of_space: '628',
#         capacity: '40',
#         open_for_schedule: true,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Wright')
#       Room.create!(
#         name: 'Wright',
#         sort_order: 106,
#         purpose: "Programming / Gaming?",
#         floor: 'Third Floor, West Tower',
#         room_set_id: panel_roomset.id,
#         venue_id: physical_venue.id,
#         length: '284',
#         width: '315',
#         height: '108',
#         area_of_space: '628',
#         capacity: '40',
#         open_for_schedule: true,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Addams')
#       Room.create!(
#         name: 'Addams',
#         sort_order: 107,
#         purpose: "Programming",
#         comment: "All Glass",
#         floor: 'Third Floor, West Tower',
#         room_set_id: panel_roomset.id,
#         venue_id: physical_venue.id,
#         length: '264',
#         width: '298',
#         height: '108',
#         area_of_space: '556',
#         capacity: '32',
#         open_for_schedule: true,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Founders Foyer')
#       Room.create!(
#         name: 'Founders Foyer',
#         sort_order: 108,
#         purpose: "Programming",
#         comment: "Not an actual room",
#         floor: 'Third Floor, West Tower',
#         room_set_id: panel_roomset.id,
#         venue_id: physical_venue.id,
#         length: '192',
#         width: '286',
#         height: '108',
#         area_of_space: '446',
#         open_for_schedule: false,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Gallery Boardroom 1')
#       Room.create!(
#         name: 'Gallery Boardroom 1',
#         sort_order: 110,
#         purpose: "Safer Spaces",
#         floor: 'Skyway Level, West Tower',
#         venue_id: physical_venue.id,
#         length: '256',
#         width: '124',
#         area_of_space: '223',
#         open_for_schedule: true,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Gallery Boardroom 2')
#       Room.create!(
#         name: 'Gallery Boardroom 2',
#         sort_order: 111,
#         purpose: "Safer Spaces",
#         floor: 'Skyway Level, West Tower',
#         venue_id: physical_venue.id,
#         length: '256',
#         width: '136',
#         area_of_space: '251',
#         open_for_schedule: true,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Gallery Boardroom 3')
#       Room.create!(
#         name: 'Gallery Boardroom 3',
#         sort_order: 112,
#         purpose: "Safer Spaces",
#         floor: 'Skyway Level, West Tower',
#         venue_id: physical_venue.id,
#         length: '256',
#         width: '146',
#         area_of_space: '258',
#         open_for_schedule: true,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Gallery Boardroom 4')
#       Room.create!(
#         name: 'Gallery Boardroom 4',
#         sort_order: 113,
#         purpose: "Safer Spaces",
#         floor: 'Skyway Level, West Tower',
#         venue_id: physical_venue.id,
#         length: '256',
#         width: '142',
#         area_of_space: '284',
#         open_for_schedule: true,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Gallery 5')
#       Room.create!(
#         name: 'Gallery 5',
#         sort_order: 114,
#         purpose: "Safer Spaces",
#         floor: 'Skyway Level, West Tower',
#         venue_id: physical_venue.id,
#         length: '213',
#         width: '340',
#         area_of_space: '470',
#         capacity: '30',
#         open_for_schedule: true,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Gallery Lounge 6')
#       Room.create!(
#         name: 'Gallery Lounge 6',
#         sort_order: 115,
#         purpose: "Public Space",
#         floor: 'Skyway Level, West Tower',
#         venue_id: physical_venue.id,
#         length: '276',
#         width: '634',
#         area_of_space: '1206',
#         open_for_schedule: false,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Gallery Lounge 7')
#       Room.create!(
#         name: 'Gallery Lounge 7',
#         sort_order: 117,
#         purpose: "Public Space",
#         floor: 'Skyway Level, West Tower',
#         venue_id: physical_venue.id,
#         length: '386',
#         width: '290',
#         area_of_space: '759',
#         open_for_schedule: false,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Crystal Ballroom A')
#       Room.create!(
#         name: 'Crystal Ballroom A',
#         sort_order: 120,
#         purpose: "Programming",
#         floor: 'Lobby Level, West Tower',
#         room_set_id: panel_roomset.id,
#         venue_id: physical_venue.id,
#         length: '516',
#         width: '708',
#         height: '228',
#         area_of_space: '2584',
#         capacity: '280',
#         open_for_schedule: true,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Crystal Ballroom B')
#       Room.create!(
#         name: 'Crystal Ballroom B',
#         sort_order: 121,
#         purpose: "Programming / WSFS",
#         comment: "WSFS BM",
#         floor: 'Lobby Level, West Tower',
#         room_set_id: panel_roomset.id,
#         venue_id: physical_venue.id,
#         length: '960',
#         width: '672',
#         height: '228',
#         area_of_space: '4669',
#         capacity: '450',
#         open_for_schedule: true,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Crystal Ballroom C')
#       Room.create!(
#         name: 'Crystal Ballroom C',
#         sort_order: 122,
#         purpose: "Programming",
#         floor: 'Lobby Level, West Tower',
#         room_set_id: panel_roomset.id,
#         venue_id: physical_venue.id,
#         length: '516',
#         width: '708',
#         height: '228',
#         area_of_space: '2586',
#         capacity: '280',
#         open_for_schedule: true,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Crystal Foyer')
#       Room.create!(
#         name: 'Crystal Foyer',
#         sort_order: 123,
#         purpose: "Programming / TableTalks",
#         floor: 'Lobby Level, West Tower',
#         venue_id: physical_venue.id,
#         area_of_space: '5120',
#         open_for_schedule: true,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Comiskey')
#       Room.create!(
#         name: 'Comiskey',
#         sort_order: 130,
#         purpose: "Children's Programming",
#         floor: 'Concourse Level, West Tower',
#         venue_id: physical_venue.id,
#         length: '480',
#         width: '744',
#         height: '108',
#         area_of_space: '1982',
#         capacity: '90',
#         open_for_schedule: true,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Water Tower')
#       Room.create!(
#         name: 'Water Tower',
#         sort_order: 131,
#         purpose: "Green Room",
#         comment: "Program to use",
#         floor: 'Concourse Level, West Tower',
#         venue_id: physical_venue.id,
#         length: '543',
#         width: '300',
#         height: '108',
#         area_of_space: '1143',
#         capacity: '120',
#         open_for_schedule: false,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Gold Coast')
#       Room.create!(
#         name: 'Gold Coast',
#         sort_order: 132,
#         purpose: "Staff Den / Dining Area",
#         floor: 'Concourse Level, West Tower',
#         venue_id: physical_venue.id,
#         length: '570',
#         width: '300',
#         height: '108',
#         area_of_space: '1178',
#         capacity: '120',
#         open_for_schedule: false,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Haymarket')
#       Room.create!(
#         name: 'Haymarket',
#         sort_order: 133,
#         purpose: "Food Prep",
#         floor: 'Concourse Level, West Tower',
#         venue_id: physical_venue.id,
#         length: '354',
#         width: '234',
#         height: '108',
#         area_of_space: '562',
#         capacity: '30',
#         open_for_schedule: false,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Picasso')
#       Room.create!(
#         name: 'Picasso',
#         sort_order: 134,
#         purpose: "Food Service",
#         comment: "not available Wed?",
#         floor: 'Concourse Level, West Tower',
#         venue_id: physical_venue.id,
#         length: '354',
#         width: '264',
#         height: '108',
#         area_of_space: '599',
#         capacity: '30',
#         open_for_schedule: false,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Columbian')
#       Room.create!(
#         name: 'Columbian',
#         sort_order: 135,
#         purpose: "Program Ops / Program Tech Ops",
#         floor: 'Concourse Level, West Tower',
#         venue_id: physical_venue.id,
#         length: '327',
#         width: '300',
#         height: '108',
#         area_of_space: '681',
#         capacity: '60',
#         open_for_schedule: false,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Soldier Field')
#       Room.create!(
#         name: 'Soldier Field',
#         sort_order: 136,
#         purpose: "Teen Lounge",
#         floor: 'Concourse Level, West Tower',
#         venue_id: physical_venue.id,
#         length: '408',
#         width: '308',
#         height: '108',
#         area_of_space: '789',
#         capacity: '45',
#         open_for_schedule: true,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Wrigley')
#       Room.create!(
#         name: 'Wrigley',
#         sort_order: 137,
#         purpose: "Programming",
#         comment: "Non traditional program / meetups?",
#         floor: 'Concourse Level, West Tower',
#         room_set_id: panel_roomset.id,
#         venue_id: physical_venue.id,
#         length: '516',
#         width: '624',
#         height: '108',
#         area_of_space: '1540',
#         capacity: '60',
#         open_for_schedule: true,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Regency Ballroom ABC')
#       Room.create!(
#         name: 'Regency Ballroom ABC',
#         sort_order: 140,
#         purpose: "Art Show",
#         floor: 'Ballroom Level, West Tower',
#         venue_id: physical_venue.id,
#         length: '864',
#         width: '208',
#         height: '140',
#         area_of_space: '12528',
#         open_for_schedule: true,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Regency Ballroom D')
#       Room.create!(
#         name: 'Regency Ballroom D',
#         sort_order: 141,
#         purpose: "Programming",
#         comment: "Tentative Chesley Awards, Art Show Auction",
#         floor: 'Ballroom Level, West Tower',
#         room_set_id: panel_roomset.id,
#         venue_id: physical_venue.id,
#         length: '864',
#         width: '696',
#         height: '140',
#         area_of_space: '4176',
#         capacity: '400',
#         open_for_schedule: true,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Regency Ballroom Main Registration Desk')
#       Room.create!(
#         name: 'Regency Ballroom Main Registration Desk',
#         sort_order: 142,
#         purpose: "Info Desk / Volunteers",
#         floor: 'Ballroom Level, West Tower',
#         venue_id: physical_venue.id,
#         open_for_schedule: false,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Regency Ballroom North Registration Desk')
#       Room.create!(
#         name: 'Regency Ballroom North Registration Desk',
#         sort_order: 143,
#         purpose: "Art Demos / Costume Repair",
#         floor: 'Ballroom Level, West Tower',
#         venue_id: physical_venue.id,
#         open_for_schedule: true,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Regency Ballroom South Registration Desk')
#       Room.create!(
#         name: 'Regency Ballroom South Registration Desk',
#         sort_order: 144,
#         purpose: "Art Demos / Costume Repair",
#         floor: 'Ballroom Level, West Tower',
#         venue_id: physical_venue.id,
#         open_for_schedule: true,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Atlanta')
#       Room.create!(
#         name: 'Atlanta',
#         sort_order: 145,
#         purpose: "Art Show Print Shop Functions? Or Programming?",
#         comment: "90% sure it's programming - need confirmation",
#         floor: 'Ballroom Level, West Tower',
#         venue_id: physical_venue.id,
#         length: '288',
#         width: '384',
#         height: '93',
#         area_of_space: '768',
#         capacity: '60',
#         open_for_schedule: true,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('International Suites  (Acapulco, Hong Kong, Toronto)')
#       Room.create!(
#         name: 'International Suites  (Acapulco, Hong Kong, Toronto)',
#         sort_order: 150,
#         purpose: "ConSuite",
#         floor: 'Ballroom Level, West Tower',
#         venue_id: physical_venue.id,
#         length: '714',
#         width: '975',
#         height: '90',
#         area_of_space: '3936',
#         open_for_schedule: false,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('New Orleans')
#       Room.create!(
#         name: 'New Orleans',
#         sort_order: 151,
#         purpose: "ConSuite Storage / Prep",
#         floor: 'Ballroom Level, West Tower',
#         venue_id: physical_venue.id,
#         length: '336',
#         width: '396',
#         height: '93',
#         area_of_space: '906',
#         capacity: '65',
#         open_for_schedule: false,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('San Francisco')
#       Room.create!(
#         name: 'San Francisco',
#         sort_order: 160,
#         purpose: "Art Special Exhibits",
#         floor: 'Ballroom Level, West Tower',
#         venue_id: physical_venue.id,
#         length: '300',
#         width: '312',
#         height: '93',
#         area_of_space: '650',
#         capacity: '55',
#         open_for_schedule: false,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Regency South Office')
#       Room.create!(
#         name: 'Regency South Office',
#         sort_order: 161,
#         purpose: "Unclaimed",
#         floor: 'Ballroom Level, West Tower',
#         venue_id: physical_venue.id,
#         open_for_schedule: false,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Board of Trade')
#       Room.create!(
#         name: 'Board of Trade',
#         sort_order: 170,
#         purpose: "WSFS Count / Various things",
#         floor: '36th Floor, West Tower',
#         venue_id: physical_venue.id,
#         length: '276',
#         width: '324',
#         area_of_space: '621',
#         open_for_schedule: false,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Stetson Suite A')
#       Room.create!(
#         name: 'Stetson Suite A',
#         sort_order: 180,
#         purpose: "Storage / TBD / Hotel?",
#         floor: 'Exhibit Level, West Tower',
#         venue_id: physical_venue.id,
#         length: '108',
#         width: '228',
#         height: '96',
#         area_of_space: '378',
#         capacity: '24',
#         open_for_schedule: false,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Stetson Suite BC')
#       Room.create!(
#         name: 'Stetson Suite BC',
#         sort_order: 181,
#         purpose: "Storage / TBD",
#         comment: "Possibly extra mobi storage",
#         floor: 'Exhibit Level, West Tower',
#         venue_id: physical_venue.id,
#         length: '360',
#         width: '204',
#         height: '96',
#         area_of_space: '510',
#         capacity: '45',
#         open_for_schedule: false,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Stetson Suite D')
#       Room.create!(
#         name: 'Stetson Suite D',
#         sort_order: 182,
#         purpose: "Storage / TBD",
#         comment: "Possibly extra mobi storage",
#         floor: 'Exhibit Level, West Tower',
#         venue_id: physical_venue.id,
#         length: '216',
#         width: '288',
#         height: '96',
#         area_of_space: '432',
#         capacity: '30',
#         open_for_schedule: false,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Stetson Suite E')
#       Room.create!(
#         name: 'Stetson Suite E',
#         sort_order: 183,
#         purpose: "Storage / TBD",
#         floor: 'Exhibit Level, West Tower',
#         venue_id: physical_venue.id,
#         length: '360',
#         width: '324',
#         height: '96',
#         area_of_space: '810',
#         capacity: '50',
#         open_for_schedule: false,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Stetson Suite F')
#       Room.create!(
#         name: 'Stetson Suite F',
#         sort_order: 184,
#         purpose: "Storage / TBD",
#         floor: 'Exhibit Level, West Tower',
#         venue_id: physical_venue.id,
#         length: '432',
#         width: '300',
#         height: '96',
#         area_of_space: '900',
#         capacity: '70',
#         open_for_schedule: false,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Stetson Suite G')
#       Room.create!(
#         name: 'Stetson Suite G',
#         sort_order: 185,
#         purpose: "Storage / TBD",
#         floor: 'Exhibit Level, West Tower',
#         venue_id: physical_venue.id,
#         length: '432',
#         width: '168',
#         height: '96',
#         area_of_space: '504',
#         capacity: '48',
#         open_for_schedule: false,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Autographing')
#       Room.create!(
#         name: 'Autographing',
#         sort_order: 200,
#         purpose: "Programming",
#         floor: 'Riverside Exhibit Hall, East Tower',
#         venue_id: physical_venue.id,
#         open_for_schedule: true,
#         is_virtual: false
#       )
#     end
#
#     unless Room.find_by_name('Airmeet 1')
#       Room.create!(
#         name: 'Airmeet 1',
#         sort_order: 501,
#         purpose: "Programming",
#         floor: 'Virtual',
#         room_set_id: virtual_roomset.id,
#         venue_id: virtual_venue.id,
#         open_for_schedule: true,
#         is_virtual: true
#       )
#     end
#
#     unless Room.find_by_name('Airmeet 2')
#       Room.create!(
#         name: 'Airmeet 2',
#         sort_order: 502,
#         purpose: "Programming",
#         floor: 'Virtual',
#         room_set_id: virtual_roomset.id,
#         venue_id: virtual_venue.id,
#         open_for_schedule: true,
#         is_virtual: true
#       )
#     end
#
#     unless Room.find_by_name('Airmeet 3')
#       Room.create!(
#         name: 'Airmeet 3',
#         sort_order: 503,
#         purpose: "Programming",
#         floor: 'Virtual',
#         room_set_id: virtual_roomset.id,
#         venue_id: virtual_venue.id,
#         open_for_schedule: true,
#         is_virtual: true
#       )
#     end
#
#     unless Room.find_by_name('Airmeet 4')
#       Room.create!(
#         name: 'Airmeet 4',
#         sort_order: 504,
#         purpose: "Programming",
#         floor: 'Virtual',
#         room_set_id: virtual_roomset.id,
#         venue_id: virtual_venue.id,
#         open_for_schedule: true,
#         is_virtual: true
#       )
#     end
#
#     unless Room.find_by_name('Stream 1')
#       Room.create!(
#         name: 'Stream 1',
#         sort_order: 511,
#         purpose: "Programming",
#         comment: "Airmeet room being streamed into",
#         floor: 'Virtual',
#         venue_id: virtual_venue.id,
#         open_for_schedule: false,
#         is_virtual: true
#       )
#     end
#
#     unless Room.find_by_name('Stream 2')
#       Room.create!(
#         name: 'Stream 2',
#         sort_order: 512,
#         purpose: "Programming",
#         comment: "Airmeet room being streamed into",
#         floor: 'Virtual',
#         venue_id: virtual_venue.id,
#         open_for_schedule: false,
#         is_virtual: true
#       )
#     end
#
#     unless Room.find_by_name('Stream 3')
#       Room.create!(
#         name: 'Stream 3',
#         sort_order: 513,
#         purpose: "Programming",
#         comment: "Airmeet room being streamed into",
#         floor: 'Virtual',
#         venue_id: virtual_venue.id,
#         open_for_schedule: false,
#         is_virtual: true
#       )
#     end
#
#   end
# end
#
# p "End room seeds"
