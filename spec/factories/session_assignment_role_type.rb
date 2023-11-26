# == Schema Information
#
# Table name: session_assignment_role_type
#
#  id                 :uuid             not null, primary key
#  default_visibility :enum             default("is_public")
#  lock_version       :integer          default(0)
#  name               :string(100)      not null
#  role_type          :enum
#  sort_order         :integer
#  created_at         :datetime
#  updated_at         :datetime
#
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
