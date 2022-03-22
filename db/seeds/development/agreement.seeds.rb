

if Agreement.count == 0

  Agreement::targets.keys.each do |target|
    creator = Person.all.sample.id
    Agreement.create(
      title: Faker::Lorem.sentence,
      terms: Faker::Lorem.sentences(number: 3).join('. '),
      agreement_type: "test",
      target: target,
      created_by_id: creator,
      updated_by_id: creator
    )
  end

end
