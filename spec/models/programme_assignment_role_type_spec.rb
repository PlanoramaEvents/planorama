require 'rails_helper'

RSpec.describe ProgrammeAssignmentRoleType do
    context 'participant enum' do
        it 'correctly returns no roles when there are no roles' do
            expect(ProgrammeAssignmentRoleType.participant).to be_empty
        end

        it 'correctly returns a role when there is one role' do
            participant_role = create(:participant_role)
            expect(ProgrammeAssignmentRoleType.participant).to_not be_empty
            expect(ProgrammeAssignmentRoleType.participant[0]).to eq participant_role
        end

        it 'correctly returns no roles when there is only staff roles' do
            staff_role = create(:staff_role)
            expect(ProgrammeAssignmentRoleType.participant).to be_empty
        end

        it 'correctly returns both roles when there are 2 roles' do
            participant_role = create(:participant_role)
            moderator_role = create(:participant_role, name: "Moderator")
            expect(ProgrammeAssignmentRoleType.participant).to_not be_empty
            expect(ProgrammeAssignmentRoleType.participant).to include participant_role
            expect(ProgrammeAssignmentRoleType.participant).to include moderator_role
        end
    end

    context 'staff enum' do
        it 'correctly returns no roles when there are no roles' do
            expect(ProgrammeAssignmentRoleType.staff).to be_empty
        end

        it 'correctly returns a role when there is one role' do
            staff_role = create(:staff_role)
            expect(ProgrammeAssignmentRoleType.staff).to_not be_empty
            expect(ProgrammeAssignmentRoleType.staff[0]).to eq staff_role
        end

        it 'correctly returns no roles when there is only participants roles' do
            participant_role = create(:participant_role)
            expect(ProgrammeAssignmentRoleType.staff).to be_empty
        end

        it 'correctly returns both roles when there are 2 roles' do
            staff_role = create(:staff_role)
            tech_role = create(:staff_role, name: "Tech Staff")
            expect(ProgrammeAssignmentRoleType.staff).to_not be_empty
            expect(ProgrammeAssignmentRoleType.staff).to include staff_role
            expect(ProgrammeAssignmentRoleType.staff).to include tech_role
        end
    end
end
