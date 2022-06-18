# Get application roles etc
class ApplicationRolesController < ResourceController
  SERIALIZER_CLASS = 'ApplicationRoleSerializer'.freeze
  POLICY_CLASS = 'ApplicationRolePolicy'.freeze
  POLICY_SCOPE_CLASS = 'ApplicationRolePolicy::Scope'.freeze

  def assign_people
    authorize current_person, policy_class: policy_class
    people_ids = params.permit(people: [:id])

    ApplicationRole.transaction do
      app_role = ApplicationRole.find params[:role_id]
      people = Person.find people_ids.to_h[:people].collect{|a| a[:id] }

      app_role.people << people

      render_object(app_role, includes: false)
    end
  end

  def unassign_people
    authorize current_person, policy_class: policy_class
    people_ids = params.permit(people: [:id])

    ApplicationRole.transaction do
      app_role = ApplicationRole.find params[:role_id]
      people = Person.find people_ids.to_h[:people].collect{|a| a[:id] }

      app_role.people.delete people

      render_object(app_role, includes: false)
    end
  end

  def assign_convention_role
    authorize current_person, policy_class: policy_class
    # con_role_ids = params.permit(convention_roles: [:id])
    #
    # ApplicationRole.transaction do
    #   app_role = ApplicationRole.find params[:role_id]
    #   con_roles = ConventionRole.find con_role_ids.to_h[:convention_roles].collect{|a| a[:id] }
    #
    #   app_role.convention_roles << con_roles
    #
    #   render_object(app_role, includes: false)
    # end
  end

  def unassign_convention_role
    authorize current_person, policy_class: policy_class
    # con_role_ids = params.permit(convention_roles: [:id])
    #
    # ApplicationRole.transaction do
    #   app_role = ApplicationRole.find params[:role_id]
    #   con_roles = ConventionRole.find con_role_ids.to_h[:convention_roles].collect{|a| a[:id] }
    #
    #   app_role.convention_roles.delete con_roles
    #
    #   render_object(app_role, includes: false)
    # end
  end

  def after_save
    after_save_or_update
  end

  def after_update
    after_save_or_update
  end

  def after_save_or_update
    p = params.permit![:permissions].to_h
    @object.update_permissions(p) if p
  end

  def paginate
    false
  end
end
