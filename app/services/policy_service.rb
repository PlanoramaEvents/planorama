# We want to get a list of the policies for a user
module PolicyService
  def self.policies_for(person:)
    Rails.application.eager_load!

    classes = ResourceController.descendants.collect{|c| name_for_class(clazz: c)}

    permissions = { }

    classes.each do |clazz|
      entity = clazz.to_s.singularize.snakecase
      permissions[entity] = {}
      policy = Pundit.policy(person, clazz.to_sym)
      # if nill use PlannerPolicy
      policy ||= Pundit.policy(person, :Planner)
      policy.public_methods(false).sort.each do |m|
        result = policy.send m
        op = m.to_s.gsub(/\?$/, '')
        permissions[entity][op] = result
      end

      if policy.class != PlannerPolicy
        super_policy = policy.class.superclass.new(person, clazz)
        super_policy.public_methods(false).sort.each do |m|
          result = policy.send m
          op = m.to_s.gsub(/\?$/, '')
          permissions[entity][op] = result
        end
      end
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
