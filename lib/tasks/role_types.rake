namespace :role_types do
  desc "Create Role Types"
  task seed_role_types: :environment do

    unless SessionAssignmentRoleType.find_by(name: 'Participant')
      SessionAssignmentRoleType.create!(
        {
          name: 'Participant',
          role_type: SessionAssignmentRoleType.role_types[:participant],
          default_visibility: SessionAssignmentRoleType.default_visibilities[:is_public]
        }
      )
    end

    unless SessionAssignmentRoleType.find_by(name: 'Moderator')
      SessionAssignmentRoleType.create!(
        {
          name: 'Moderator',
          role_type: SessionAssignmentRoleType.role_types[:participant],
          default_visibility: SessionAssignmentRoleType.default_visibilities[:is_public]
        }
      )
    end

    unless SessionAssignmentRoleType.find_by(name: 'Reserve')
      SessionAssignmentRoleType.create!(
        {
          name: 'Reserve',
          role_type: SessionAssignmentRoleType.role_types[:participant],
          default_visibility: SessionAssignmentRoleType.default_visibilities[:is_private]
        }
      )
    end

    # This is kind of redundant...
    unless SessionAssignmentRoleType.find_by(name: 'Invisible')
      SessionAssignmentRoleType.create!(
        {
          name: 'Invisible',
          role_type: SessionAssignmentRoleType.role_types[:participant],
          default_visibility: SessionAssignmentRoleType.default_visibilities[:is_private]
        }
      )
    end

  end
end
