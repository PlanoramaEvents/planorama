if !Room.find_by(name: 'Room Dimensions')
  r = Room.create(
    name: 'Room Dimensions',
    purpose: "For discussion of " + Faker::Science.science,
    comment: Faker::Movie.quote,
    sort_order: Faker::Number.unique.number(digits: 3),
    capacity: Faker::Number.unique.number(digits: 3),
    floor: Faker::Number.between(from: 1, to: 10),
    open_for_schedule: true,
    is_virtual: false,
    length: 400,
    width: 893,
    height: 102
  )
  p "Made " + r.name
end


# roomset = RoomSet.find_by_name('Panel')
# p "Room Set " + roomset.name + ' ' + roomset.id
#
# if !Room.find_by(name: 'Room with Room Set')
#   r = Room.create(
#     name: 'Room with Room Set',
#     purpose: "For discussion of " + Faker::Science.science,
#     comment: Faker::Movie.quote,
#     sort_order: Faker::Number.unique.number(digits: 3),
#     capacity: Faker::Number.unique.number(digits: 3),
#     floor: Faker::Number.between(from: 1, to: 10),
#     open_for_schedule: true,
#     is_virtual: false,
#     length: 2556,
#     width: 1368,
#     height: 204,
#     room_set_id: roomset.id
#   )
#   p "Made " + r.name
# end
