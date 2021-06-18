
Person.delete_all


100.times.each do |i|
    registered = Faker::Boolean.boolean(true_ratio: 0.5)
    registration_number = ''
    registration_type = ''

    if registered == true
        registration_number = i + 1000
        registration_type = %w[supporting adult child teen ya first].sample
    end

    person = Person.create(
        #prefix
        first_name: Faker::Name.unique.first_name,
        last_name: Faker::Name.unique.last_name,
        #suffix
        #pseudonym_prefix
        #pseudonym_first_name
        #pseudonym_last_name
        #pseudonym_suffix
        #published_name
        #published_last_name
        organization: Faker::Company.name,
        job_title: Faker::Company.profession,
        pronouns: %w[he/him she/her they/them ze/zir].sample,
        gender: Faker::Gender.type,
        year_of_birth: Faker::Date.between(from: 90.years.ago, to: 1.year.ago).year,
        ethnicity: Faker::Demographic.race,
        opted_in: Faker::Boolean.boolean(true_ratio: 0.9),
        comments: Faker::Books::Dune.quote,
        can_share: Faker::Boolean.boolean(true_ratio: 0.9),
        can_photo: Faker::Boolean.boolean(true_ratio: 0.8),
        can_record: Faker::Boolean.boolean(true_ratio: 0.7),
        invite_status: %w[not_set do_not_invite potential_invite invite_pending invited volunteered].sample,
        acceptance_status: %w[unknown probable accepted declined].sample,
        registered: registered,
        registration_number: registration_number,
        registration_type: registration_type,
        bio: Bio.create(
            bio: Faker::Lorem.sentences(number: 3),
            website: Faker::Internet.url
            #twitterinfo text,
            #othersocialmedia text,
            #photourl text,
            #facebook text,
            #linkedin text,
            #twitch text,
            #youtube text,
            #instagram text,
            #flickr text,
            #reddit text
        )
    )
    e = person.first_name + '_' + person.last_name + i.to_s + '@test.com'
    EmailAddress.create(
        person: person,
        isdefault: true,
        email: e,
        is_valid: true
    )
    secondary = Faker::Boolean.boolean(true_ratio: 0.5)
    if secondary == true
        e = person.first_name + '_' + person.last_name + '_second' + '@test.com'
        EmailAddress.create(
            person: person,
            isdefault: false,
            email: e,
            is_valid: true
        )
    end
    username = person.first_name[0] + person.last_name        #get first letter of first name + last name
    #p "Username: " + username
    person.bio.twitterinfo = username
    person.bio.facebook = username
    person.bio.linkedin = username
    person.bio.twitch = username
    person.bio.youtube = username
    person.bio.instagram = username
    person.bio.flickr = username
    person.bio.reddit = username
    person.bio.save
    #p "Twitter is #{person.bio.twitterinfo}"
    
end

p "Created #{Person.count} people."
