FactoryBot.define do
    factory :programme_item do
        title { Faker::Educator.course_name }
        format

        factory :panel do
            title { "a panel" }
            duration { 50 }
            minimum_people { 3 }
            maximum_people { 6 }
            audience_size { 100 }
            start_time { Faker::Time.forward(days: 5) }
        end

        factory :programme_item_with_participants do
            after(:create) do |prog|
                create_list(:programme_assignment, 5, programme_item: prog, programme_assignment_role_type: create(:participant_role))
            end
        end
    end
end
