FactoryBot.define do
  factory :person do
    name { Faker::Name.name }
    name_sort_by { "#{name}" }
    organization { Faker::Company.name }
    job_title { Faker::Company.profession }
    gender { Faker::Gender.type }
    year_of_birth { Faker::Date.between(from: 90.years.ago, to: 1.year.ago).year }
    pseudonym { nil }
    pseudonym_sort_by { nil }

    after(:create) do |person|
      create_list(:email_address, 1, person: person, email: Faker::Internet.email(name: "#{person.name}"))
      person.reload
    end

    factory :pseudonym_person do
      pseudonym { Faker::Name.name }
      pseudonym_sort_by { "#{pseudonym}" }
    end

    factory :registered_person do
      registered { true }
      # TODO make these more realistic
      registration_number { "123456" }
      registration_type { "adult" }
    end
  end

end
