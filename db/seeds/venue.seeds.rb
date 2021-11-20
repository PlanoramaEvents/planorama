if Person.count == 0
  3.times.each do |i|
      v = Venue.create(
          name: Faker::Space.unique.planet,
          sort_order: Faker::Number.unique.number(digits: 2)
      )
      5.times.each do |j|
          Room.create(
              name: Faker::Mountain.unique.name,
              venue: v,
              sort_order: Faker::Number.unique.number(digits: 3)
          )
      end
  end

  p "Created #{Venue.count} venues with #{Room.count} rooms."
end
