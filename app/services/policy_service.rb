# We want to get a list of the policies for a user
module PolicyService
  def self.policies_for(person:)
    Rails.application.eager_load! # ensure that the controller classes are loaded

    classes = ResourceController.descendants.collect{|c| name_for_class(clazz: c)}

    permissions = { }

    classes.each do |clazz|
      entity = clazz.to_s.singularize.snakecase
      permissions[entity] = {}
      policy = Pundit.policy(person, clazz.to_sym)
      policy ||= Pundit.policy(person, :Planner) # if nill use PlannerPolicy
      build_policy_entries(permissions: permissions[entity], policy: policy)

      next unless policy.class != PlannerPolicy

      super_policy = policy.class.superclass.new(person, clazz)
      build_policy_entries(permissions: permissions[entity], policy: super_policy)
    end

    permissions
  end

  def self.build_policy_entries(permissions:, policy:)
    policy.public_methods(false).sort.each do |m|
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
