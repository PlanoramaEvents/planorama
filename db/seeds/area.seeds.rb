p "Start area seeds"

unless Area.find_by_name('1946 Project')
  Area.create!(
    name: "1946 Project",
    sort_order: 1
  )
end

unless Area.find_by_name('Anime')
  Area.create!(
    name: "Anime",
    sort_order: 2
  )
end

unless Area.find_by_name('Art')
  Area.create!(
    name: "Art",
    sort_order: 3
  )
end

unless Area.find_by_name('Childrens Program')
  Area.create!(
    name: "Childrens Program",
    sort_order: 4
  )
end

unless Area.find_by_name('Comics')
  Area.create!(
    name: "Comics",
    sort_order: 5
  )
end

unless Area.find_by_name('Costuming & Cosplay')
  Area.create!(
    name: "Costuming & Cosplay",
    sort_order: 6
  )
end

unless Area.find_by_name('Events')
  Area.create!(
    name: "Events",
    sort_order: 7
  )
end

unless Area.find_by_name('Fandom')
  Area.create!(
    name: "Fandom",
    sort_order: 8
  )
end

unless Area.find_by_name('Gaming Program')
  Area.create!(
    name: "Gaming Program",
    sort_order: 9
  )
end

unless Area.find_by_name('Literature')
  Area.create!(
    name: "Literature",
    sort_order: 10
  )
end

unless Area.find_by_name('Maker')
  Area.create!(
    name: "Maker",
    sort_order: 11
  )
end

unless Area.find_by_name('Media')
  Area.create!(
    name: "Media",
    sort_order: 12
  )
end

unless Area.find_by_name('Meetups')
  Area.create!(
    name: "Meetups",
    sort_order: 13
  )
end

unless Area.find_by_name('Music & Filk')
  Area.create!(
    name: "Music & Filk",
    sort_order: 14
  )
end

unless Area.find_by_name('Podcasting')
  Area.create!(
    name: "Podcasting",
    sort_order: 15
  )
end

unless Area.find_by_name('Polish SFF')
  Area.create!(
    name: "Polish SFF",
    sort_order: 16
  )
end

unless Area.find_by_name('Science & Technology')
  Area.create!(
    name: "Science & Technology",
    sort_order: 17
  )
end

unless Area.find_by_name('Society')
  Area.create!(
    name: "Society",
    sort_order: 18
  )
end

unless Area.find_by_name('Theater Program')
  Area.create!(
    name: "Theater Program",
    sort_order: 19
  )
end

unless Area.find_by_name('Virtual')
  Area.create!(
    name: "Virtual",
    sort_order: 20
  )
end

unless Area.find_by_name('Writing')
  Area.create!(
    name: "Writing",
    sort_order: 21
  )
end


p "End area seeds"

