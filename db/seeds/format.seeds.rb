p "Start format seeds"

unless Format.find_by_name('Panel')
  Format.create!(
    name: 'Panel',
    position: 1
  )
end

unless Format.find_by_name('Presentation')
  Format.create!(
    name: 'Presentation',
    position: 2
  )
end

unless Format.find_by_name('Workshop')
  Format.create!(
    name: 'Workshop',
    position: 3
  )
end

unless Format.find_by_name('Discussion')
  Format.create!(
    name: 'Discussion',
    position: 4
  )
end

unless Format.find_by_name('Interview')
  Format.create!(
    name: 'Interview',
    position: 5
  )
end

unless Format.find_by_name('Meetup')
  Format.create!(
    name: 'Meetup',
    position: 6
  )
end

unless Format.find_by_name('Other')
  Format.create!(
    name: 'Other',
    position: 7
  )
end

p "End format seeds"
