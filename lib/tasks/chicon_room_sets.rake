namespace :chicon do
  desc "Seed Chicon Room Set Data"
  task seed_room_sets: :environment do
    if RoomSet.count == 0
      RoomSet.create!(
        [
          {
            name: "Panel",
            description: "Tables set at front of room with chairs in rows facing tables.",
            sort_order: 1
          },
          {
            name: "Theater",
            description: "Stage set at from of room with chairs set facing stage.",
            sort_order: 2
          },
          {
            name: "U Shape Table",
            description: "Make a U shape using tables with chairs on outside of U shape.",
            sort_order: 3
          },
          {
            name: "Circle of Chairs",
            description: "Circle of chairs.",
            sort_order: 4
          },
          {
            name: "None",
            description: "No room set up needed.",
            sort_order: 5
          },
          {
            name: "Autograph Table",
            description: "1 table set with 4 chairs",
            sort_order: 6
          },
          {
            name: "Banquet",
            description: "Banquet",
            sort_order: 7
          },
          {
            name: "Reception",
            description: "Reception",
            sort_order: 8
          },
          {
            name: "Classroom",
            description: "Classroom",
            sort_order: 9
          },
          {
            name: "Hollow Square",
            description: "Hollow Square",
            sort_order: 10
          },
          {
            name: "Virtual Room",
            description: "A virtual Room.",
            sort_order: 11
          },
          {
            name: "Other (describe)",
            description: "Other",
            sort_order: 20
          },
          {
            name: "I do not know",
            description: "NA",
            sort_order: 99
          }
        ]
      )
    end
  end


end
