FactoryBot.define do
  factory :room do
    sequence(:name) { |n| "my room #{n}" }
    venue

    factory :room_with_detail do
      purpose { "This is the purpose of the room." }
      comment { "This is a comment on the room." }
      sort_order { Faker::Number.number(digits: 2) }
      capacity { Faker::Number.number(digits: 3) }
    end
  end
end
