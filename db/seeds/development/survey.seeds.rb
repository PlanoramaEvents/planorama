#surveys


Survey.delete_all

10.times.each do |i|
    name = 'Survey ' + i.to_s + ': ' + Faker::Books::CultureSeries.book
    Survey.create(
      name: name,
      thank_you: Faker::Lorem.sentence,
      alias: name.gsub(/\s+/, '_'),
      submit_string: 'submit',
      header_image: Faker::LoremFlickr.image(size: "1000x100"),
      use_captcha: Faker::Boolean.boolean(true_ratio: 0.8),
      public: Faker::Boolean.boolean(true_ratio: 0.8),
      authenticate: Faker::Boolean.boolean(true_ratio: 0.8),
      transition_accept_status: [nil, :probable, :accepted].sample,
      transition_decline_status: [nil, :unknown, :probable, :declined].sample,
      welcome: Faker::Lorem.sentence,
      declined_msg: Faker::Lorem.sentence,
      authenticate_msg: Faker::Lorem.sentence,
      anonymous: Faker::Boolean.boolean(true_ratio: 0.8)
    )
  end


p "Created #{Survey.count} surveys."
