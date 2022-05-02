# Get application roles etc
class ApplicationRolesController < ResourceController
  SERIALIZER_CLASS = 'ApplicationRoleSerializer'.freeze
  POLICY_CLASS = 'ApplicationRolePolicy'.freeze
  POLICY_SCOPE_CLASS = 'ApplicationRolePolicy::Scope'.freeze

  # Get all roles
  # Get roles for a specific Person
  # Get the role by a specific Name
  # Save/update the role's permissions

  def paginate
    false
  end
end
