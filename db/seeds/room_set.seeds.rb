p "Start room_set seeds"


unless RoomSet.find_by(name: 'Panel')
  RoomSet.create!(
      name: "Panel",
      description: "Tables set at front of room with chairs in rows facing tables.",
      sort_order: 1
  )
end

unless RoomSet.find_by(name: 'Theater')
  RoomSet.create!(
      name: "Theater",
      description: "Stage set at from of room with chairs set facing stage.",
      sort_order: 2
  )
end

unless RoomSet.find_by(name: 'U Shape Table')
  RoomSet.create!(
      name: "U Shape Table",
      description: "Make a U shape using tables with chairs on outside of U shape.",
      sort_order: 3
  )
end

unless RoomSet.find_by(name: 'Circle of Chairs')
  RoomSet.create!(
      name: "Circle of Chairs",
      description: "Circle of chairs.",
      sort_order: 4
  )
end

unless RoomSet.find_by(name: 'None')
  RoomSet.create!(
      name: "None",
      description: "No room set up needed.",
      sort_order: 5
  )
end

unless RoomSet.find_by(name: 'Autograph Table')
  RoomSet.create!(
      name: "Autograph Table",
      description: "1 table set with 4 chairs",
      sort_order: 6
  )
end

unless RoomSet.find_by(name: 'Banquet')
  RoomSet.create!(
      name: "Banquet",
      description: "Banquet",
      sort_order: 7
  )
end

unless RoomSet.find_by(name: 'Reception')
  RoomSet.create!(
      name: "Reception",
      description: "Reception",
      sort_order: 8
  )
end

unless RoomSet.find_by(name: 'Classroom')
  RoomSet.create!(
      name: "Classroom",
      description: "Classroom",
      sort_order: 9
  )
end

unless RoomSet.find_by(name: 'Hollow Square')
  RoomSet.create!(
      name: "Hollow Square",
      description: "Hollow Square",
      sort_order: 10
  )
end

unless RoomSet.find_by(name: 'Virtual Room')
  RoomSet.create!(
      name: "Virtual Room",
      description: "A virtual Room.",
      sort_order: 11
  )
end

unless RoomSet.find_by(name: 'Other (describe)')
  RoomSet.create!(
      name: "Other (describe)",
      description: "Other",
      sort_order: 20
  )
end

unless RoomSet.find_by(name: 'I do not know')
  RoomSet.create!(
      name: "I do not know",
      description: "NA",
      sort_order: 99
  )
end

p "End room_set seeds"
