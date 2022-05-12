if Venue.count == 0
  2.times.each do |i|
      v = Venue.create(
          name: Faker::Space.unique.planet,
          sort_order: Faker::Number.unique.number(digits: 2),
          address: Faker::Address.full_address
      )
      5.times.each do |j|
          Room.create(
              name: Faker::Color.unique.color_name.capitalize,
              venue: v,
              purpose: "For discussion of " + Faker::Science.science,
              comment: Faker::Movie.quote,
              sort_order: Faker::Number.unique.number(digits: 3),
              capacity: Faker::Number.unique.number(digits: 3),
              # room_floor: Faker::Number.between(from: 1, to: 10),
              open_for_schedule: Faker::Boolean.boolean(true_ratio: 0.9),
              is_virtual: false
          )
      end
  end

  v = Venue.create(
    name: "Virtual Venue",
    sort_order: Faker::Number.unique.number(digits: 2),
    address: "virtual"
  )
  5.times.each do |j|
    Room.create(
        name: "Virtual " + Faker::Color.unique.color_name.capitalize,
        venue: v,
        purpose: "For discussion of " + Faker::Hobby.activity,
        comment: Faker::Movie.quote,
        sort_order: Faker::Number.unique.number(digits: 3),
        open_for_schedule: true,
        is_virtual: true
)
  end

  p "Created #{Venue.count} venues with #{Room.count} rooms."
end
