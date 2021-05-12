FactoryBot.define do
    factory :venue do
        name { Faker::Space.planet + " Hotel" }

        factory :venue_with_sort_order do
            sort_order { Faker::Number.number(digits: 2) }
        end
    end
end
