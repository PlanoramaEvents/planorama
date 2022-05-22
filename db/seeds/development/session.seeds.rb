p "Start development session seeds"

return if Session.count > 0

unless Format.find_by_name('Panel')
  Format.create!(
    name: 'Panel',
    position: 1
  )
end

unless Format.find_by_name('Talk')
  Format.create!(
    name: 'Talk',
    position: 2
  )
end

panel = Format.find_by_name('Panel')
talk = Format.find_by_name('Talk')

100.times.each do |i|
  format = i % 2 ? panel : talk
  Session.create(
    title: Faker::Book.unique.title,
    description: Faker::TvShows::TheExpanse.quote,
    format_id: format.id,
    audience_size: 100
  )
end

p "End development session seeds"
