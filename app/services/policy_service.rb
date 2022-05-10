# We want to get a list of the policies for a user
module PolicyService
  def self.list_policies
    Rails.application.eager_load! # ensure that the controller classes are loaded

    classes = ResourceController.descendants.collect{|c| name_for_class(clazz: c)}

    permissions = { }

    classes.each do |clazz|
      entity = clazz.to_s.singularize.snakecase.split('::').last
      permissions[entity] = {}
      policy = Pundit.policy(nil, clazz.to_sym)
      policy ||= Pundit.policy(nil, :Planner) # if nill use PlannerPolicy
      build_policy_list(permissions: permissions[entity], policy: policy)

      next unless policy.class != PlannerPolicy

      super_policy = policy.class.superclass.new(nil, clazz)
      build_policy_list(permissions: permissions[entity], policy: super_policy)
    end

    permissions
  end

  def self.policies_for(person:)
    return RequestStore.store["#{person}_policies"] if RequestStore.store["#{person}_policies"]

    Rails.application.eager_load! # ensure that the controller classes are loaded

    classes = ResourceController.descendants.collect{|c| name_for_class(clazz: c)}

    permissions = list_policies # default set (which we can not do anything but list the policies)
    permissions[:sensitive_access] = false

    # TODO: we need to go through the roles as well ... to cover the ones not in pundit
    # Why called many times ??
    person.convention_roles.each do |con_role|
      con_role.application_roles.each do |role|
        permissions[:sensitive_access] = permissions[:sensitive_access] || role.sensitive_access
        merge_permissions(to: permissions, from: role.model_permissions)
      end
    end

    person.application_roles.each do |role|
      permissions[:sensitive_access] = permissions[:sensitive_access] || role.sensitive_access
      merge_permissions(to: permissions, from: role.model_permissions)
    end

    RequestStore.store["#{person}_policies"] ||= permissions
    RequestStore.store["#{person}_policies"]
  end

  def self.merge_permissions(to:, from:)
    from.each do |p|
      if to[p.mdl_name]
        to[p.mdl_name] = to[p.mdl_name].merge p.actions
      else
        to[p.mdl_name] = p.actions
      end
    end
  end

  def self.build_policy_list(permissions:, policy:)
    policy.public_methods(false).sort.each do |m|
      next unless m.end_with?("?") && m != :'allowed?'

      # result = policy.send m
      op = m.to_s.gsub(/\?$/, '')
      permissions[op] = false
    end

    permissions
  end

  def self.build_policy_entries(permissions:, policy:)
    policy.public_methods(false).sort.each do |m|
      next unless m.end_with? "?"

      result = policy.send m
      op = m.to_s.gsub(/\?$/, '')
      permissions[op] = result
    end

    permissions
  end

  def self.name_for_class(clazz:)
    if defined?(self.class::MODEL_CLASS)
      clazz::MODEL_CLASS #.constantize
    else
      clazz.name.sub('Controller', '') #.singularize #.constantize
    end
  end
end
