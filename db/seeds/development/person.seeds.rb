p "Start development person seeds"

if Person.count < 100
  100.times.each do |i|
    registered = Faker::Boolean.boolean(true_ratio: 0.5)
    registration_number = ''
    registration_type = ''

    if registered == true
      registration_number = i + 1000
      registration_type = %w[supporting adult child teen ya first].sample
    end

    name = Faker::Name.name
    username = name.gsub(' ','_')
    person = Person.create(
        name: name,
        name_sort_by: name,
        name_sort_by_confirmed: true,
        organization: Faker::Company.name,
        job_title: Faker::Company.profession,
        pronouns: %w[he/him she/her they/them ze/zir].sample,
        gender: Faker::Gender.type,
        year_of_birth: Faker::Date.between(from: 90.years.ago, to: 1.year.ago).year,
        ethnicity: Faker::Demographic.race,
        opted_in: Faker::Boolean.boolean(true_ratio: 0.9),
        comments: Faker::Books::Dune.quote,
        con_state: %w[not_set accepted].sample,
        registered: registered,
        registration_number: registration_number,
        registration_type: registration_type,
        bio: Faker::Lorem.sentences(number: 3).join('. '),
        pseudonym: username,
        website: Faker::Internet.url,
        twitter: username,
        othersocialmedia: username,
        facebook: username,
        linkedin: username,
        twitch: username,
        youtube: username,
        instagram: username,
        flickr: username,
        reddit: username,
        tiktok: username,
        attendance_type: ['in_person', 'virtual', 'hybrid'].sample
    )
    e = name.gsub(' ', '_') + i.to_s + '@test.com'
    EmailAddress.create(
        person: person,
        isdefault: true,
        email: e,
        is_valid: true
    )
    secondary = Faker::Boolean.boolean(true_ratio: 0.5)
    if secondary == true
      e = name.gsub(' ', '_') + '_second' + '@test.com'
      EmailAddress.create(
          person: person,
          isdefault: false,
          email: e,
          is_valid: true
      )
    end

    ConventionRole.create(
        person: person,
        role: ConventionRole.roles[:participant]
      )
  end

  p "Created #{Person.count} people."
end

p "End development person seeds"
