FactoryBot.define do
  factory :email_address do
    isdefault { true }
    email { Faker::Internet.safe_email }
    person
  end
end
