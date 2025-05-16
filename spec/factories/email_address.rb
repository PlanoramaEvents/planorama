FactoryBot.define do
  factory :email_address do
    isdefault { true }
    email { Faker::Internet.email }
    person
  end
end
