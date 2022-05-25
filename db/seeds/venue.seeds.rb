p "Start venue seeds"

unless Venue.find_by_name('Hyatt Regency Chicago')
  Venue.create!(
    name: 'Hyatt Regency Chicago',
    sort_order: 1,
    address: '151 E Wacker Drive, Chicago IL 60601'
  )
end

unless Venue.find_by_name('Airmeet')
  Venue.create!(
    name: 'Airmeet',
    sort_order: 2,
    address: 'Airmeet link?'
  )
end

p "End venue seeds"
