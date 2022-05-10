if !Roomset.find_by(name: 'Panel')
  Roomset.create(
      name: "Panel",
      description: "Tables set at front of room with chairs in rows facing tables.",
      sort_order: 1
  )
end

if !Roomset.find_by(name: 'Theater')
  Roomset.create(
      name: "Theater",
      description: "Stage set at from of room with chairs set facing stage.",
      sort_order: 2
  )
end

if !Roomset.find_by(name: 'U Shape Table')
  Roomset.create(
      name: "U Shape Table",
      description: "Make a U shape using tables with chairs on outside of U shape.",
      sort_order: 3
  )
end

if !Roomset.find_by(name: 'Circle of Chairs')
  Roomset.create(
      name: "Circle of Chairs",
      description: "Circle of chairs.",
      sort_order: 4
  )
end

if !Roomset.find_by(name: 'None')
  Roomset.create(
      name: "None",
      description: "No room set up needed.",
      sort_order: 5
  )
end

if !Roomset.find_by(name: 'Autograph Table')
  Roomset.create(
      name: "Autograph Table",
      description: "1 table set with 4 chairs",
      sort_order: 6
  )
end

if !Roomset.find_by(name: 'Banquet')
  Roomset.create(
      name: "Banquet",
      description: "Banquet",
      sort_order: 7
  )
end

if !Roomset.find_by(name: 'Reception')
  Roomset.create(
      name: "Reception",
      description: "Reception",
      sort_order: 8
  )
end

if !Roomset.find_by(name: 'Classroom')
  Roomset.create(
      name: "Classroom",
      description: "Classroom",
      sort_order: 9
  )
end

if !Roomset.find_by(name: 'Hollow Square')
  Roomset.create(
      name: "Hollow Square",
      description: "Hollow Square",
      sort_order: 10
  )
end

if !Roomset.find_by(name: 'Virtual Room')
  Roomset.create(
      name: "Virtual Room",
      description: "A virtual Room.",
      sort_order: 11
  )
end

if !Roomset.find_by(name: 'Other (describe)')
  Roomset.create(
      name: "Other (describe)",
      description: "Other",
      sort_order: 20
  )
end

if !Roomset.find_by(name: 'I do not know')
  Roomset.create(
      name: "I do not know",
      description: "NA",
      sort_order: 99
  )
end

p "Roomsets created if they didn't already exist."