p "Start development room seeds"

linear_measurement = LinearUnit.find_by_name('inch')
area_measurement = AreaUnit.find_by_name('square feet')

unless Room.find_by(name: 'Room Dimensions')
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
    height: 102,
    area_of_space: '2475',
    linear_unit_id: linear_measurement.id,
    area_unit_id: area_measurement.id
  )
  p "Made " + r.name
end


roomset = RoomSet.find_by_name('Panel')


unless Room.find_by(name: 'Room with Room Set')
  r = Room.create(
    name: 'Room with Room Set',
    purpose: "For discussion of " + Faker::Science.science,
    comment: Faker::Movie.quote,
    sort_order: Faker::Number.unique.number(digits: 3),
    capacity: Faker::Number.unique.number(digits: 3),
    floor: Faker::Number.between(from: 1, to: 10),
    open_for_schedule: true,
    is_virtual: false,
    length: 2556,
    width: 1368,
    height: 204,
    area_of_space: '24282',
    linear_unit_id: linear_measurement.id,
    area_unit_id: area_measurement.id,
    room_set_id: roomset.id
  )
  p "Made " + r.name
end

p "End development room seeds"

