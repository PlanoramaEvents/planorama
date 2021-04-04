FactoryBot.define do
    factory :programme_item do
        title { Faker::Educator.course_name }
        format
        setup_type

        factory :panel do
            title { "a panel" }
            duration { 50 }
            minimum_people { 3 }
            maximum_people { 6 }
            audience_size { 100 }
            start_time { Faker::Time.forward(days: 5) }
        end
    end
end
