FactoryBot.define do
    factory :room do
        sequence(:name) { |n| "my room #{n}" }
        venue
        setup_type
    end
end
