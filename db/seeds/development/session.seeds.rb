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

unless Area.find_by_name('Fandom')
  Area.create!(
    name: 'Fandom',
    position: 8
  )
end

panel = Format.find_by_name('Panel')
talk = Format.find_by_name('Talk')
#area = Area.find_by_name('Fandom')

90.times.each do |i|
  format = i % 2 ? panel : talk
  area = Area.all.sample
  s = Session.create!(
    title: Faker::Book.unique.title,
    description: Faker::TvShows::TheExpanse.quote,
    format_id: format.id,
    audience_size: 100,
    duration: 30 * ((i % 2) + 1),
    open_for_interest: Faker::Boolean.boolean(true_ratio: 0.8),
    require_signup: Faker::Boolean.boolean(true_ratio: 0.2),
    item_notes: "Test of the item_notes field",
    participant_notes: "Test of the participant_notes field",
    instructions_for_interest: "Test of the instructions_for_interest field"
  )
  SessionArea.create!(
    session_id: s.id,
    area_id: area.id
  )
end

10.times.each do |i|
  format = Format.all.sample
  area = Area.all.sample
  s = Session.create!(
    title: Faker::Book.unique.title,
    description: Faker::TvShows::TheExpanse.quote,
    format_id: format.id,
    audience_size: 100,
    duration: 30 * ((i % 2) + 1),
    open_for_interest: Faker::Boolean.boolean(true_ratio: 0.8),
    require_signup: Faker::Boolean.boolean(true_ratio: 0.2),
    item_notes: "Test of the item_notes field",
    participant_notes: "Test of the participant_notes field",
    instructions_for_interest: "Test of the instructions_for_interest field"
  )
  SessionArea.create!(
    session_id: s.id,
    area_id: area.id
  )
end


p "End development session seeds: #{Session.count}"
