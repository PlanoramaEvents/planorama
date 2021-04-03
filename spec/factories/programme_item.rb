FactoryBot.define do
    factory :programme_item do
        title { Faker::Educator.course_name }
        format
        setup_type

        factory :panel do
            title { "a panel" }
            format factory: :format, name: "panel"
        end
    end
end
