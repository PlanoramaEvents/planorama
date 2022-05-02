# Get application roles etc
class ApplicationRolesController < ResourceController
  SERIALIZER_CLASS = 'ApplicationRoleSerializer'.freeze
  POLICY_CLASS = 'ApplicationRolePolicy'.freeze
  POLICY_SCOPE_CLASS = 'ApplicationRolePolicy::Scope'.freeze

  def after_save
    p = params.permit![:permissions].to_h
    @object.create_permissions(p) if p
  end

  def after_update
    p = params.permit![:permissions].to_h
    @object.update_permissions(p) if p
  end

  def paginate
    false
  end
end
