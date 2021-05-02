after :setup_type do
    
    Venue.delete_all
    Room.delete_all

    st = SetupType.first

    3.times.each do |i|
        v = Venue.create(
            name: Faker::Space.unique.planet,
            sort_order: Faker::Number.unique.number(digits: 2)
        )
        5.times.each do |j|
            Room.create(
                name: Faker::Mountain.unique.name,
                venue: v,
                setup_type: st,
                sort_order: Faker::Number.unique.number(digits: 3)
            )
        end

    end

    p "Created #{Venue.count} venues with #{Room.count} rooms."

end
