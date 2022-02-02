FactoryBot.define do
    factory :session_assignment do
        person
        session
        session_assignment_role_type
    end
end
