FactoryBot.define do
  factory :format do
    sequence(:name) { |n| "panel #{n}" }
    sequence(:position)
  end
end
