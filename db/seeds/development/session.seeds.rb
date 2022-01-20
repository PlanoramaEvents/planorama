#
return if Session.count > 0

panel = Format.create(
  name: 'Panel'
)

talk = Format.create(
  name: 'Talk'
)

100.times.each do |i|
  format = i % 2 ? panel : talk
  Session.create(
    title: Faker::Book.unique.title,
    description: Faker::TvShows::TheExpanse.quote,
    format_id: format.id,
    audience_size: 100
  )
end
