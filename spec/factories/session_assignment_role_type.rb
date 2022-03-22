FactoryBot.define do
    factory :session_assignment_role_type do
        sequence :id
        sequence(:name) { |n| "session assignment role type #{n}"}

        factory :participant_role do
            name { 'Participant' }
            role_type { 'participant' }
            default_visibility { 'public' }
        end

        factory :staff_role do
            name { 'Staff' }
            role_type { 'staff' }
            default_visibility { 'private' }
        end
    end
end
