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
require 'rails_helper'

RSpec.describe SessionAssignmentRoleType do
  context 'participant enum' do
    it 'correctly returns no roles when there are no roles' do
      expect(SessionAssignmentRoleType.participant).to be_empty
    end

    it 'correctly returns a role when there is one role' do
      participant_role = create(:participant_role)
      expect(SessionAssignmentRoleType.participant).to_not be_empty
      expect(SessionAssignmentRoleType.participant[0]).to eq participant_role
    end

    it 'correctly returns no participant roles when there is only staff roles' do
      staff_role = create(:staff_role)
      expect(SessionAssignmentRoleType.participant).to be_empty
    end

    it 'correctly returns both roles when there are 2 roles' do
      participant_role = create(:participant_role)
      moderator_role = create(:participant_role, name: "Moderator")
      expect(SessionAssignmentRoleType.participant).to_not be_empty
      expect(SessionAssignmentRoleType.participant).to include participant_role
      expect(SessionAssignmentRoleType.participant).to include moderator_role
    end
  end

  context 'staff enum' do
    it 'correctly returns no roles when there are no roles' do
      expect(SessionAssignmentRoleType.staff).to be_empty
    end

    it 'correctly returns a role when there is one role' do
      staff_role = create(:staff_role)
      expect(SessionAssignmentRoleType.staff).to_not be_empty
      expect(SessionAssignmentRoleType.staff[0]).to eq staff_role
    end

    it 'correctly returns no staff roles when there is only participants roles' do
      participant_role = create(:participant_role)
      expect(SessionAssignmentRoleType.staff).to be_empty
    end

    it 'correctly returns both roles when there are 2 roles' do
      staff_role = create(:staff_role)
      tech_role = create(:staff_role, name: "Tech Staff")
      expect(SessionAssignmentRoleType.staff).to_not be_empty
      expect(SessionAssignmentRoleType.staff).to include staff_role
      expect(SessionAssignmentRoleType.staff).to include tech_role
    end
  end
end
