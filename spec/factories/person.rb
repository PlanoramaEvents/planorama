FactoryBot.define do
    factory :person do
        first_name { Faker::Name.first_name }
        last_name { Faker::Name.last_name }
        organization { Faker::Company.name }
        job_title { Faker::Company.profession }
        gender { Faker::Gender.type }
        year_of_birth { Faker::Date.between(from: 90.years.ago, to: 1.year.ago).year }
        pseudonym_first_name { nil }
        pseudonym_last_name { nil }

        after(:create) do |person|
            create_list(:email_address, 1, person: person, email: Faker::Internet.safe_email(name: "#{person.first_name} #{person.last_name}"))
            person.reload
        end

        factory :pseudonym_person do
            pseudonym_first_name { Faker::Name.first_name }
            pseudonym_last_name { Faker::Name.last_name }
        end

        factory :registered_person do
            registered { true }
            # TODO make these more realistic
            registration_number { "123456" }
            registration_type { "adult_full" }
        end
    end

end
