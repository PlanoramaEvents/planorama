# We want to get a list of the policies for a user
module PolicyService
  def self.policies_for(person:)
    classes = [:Submissions, :Surveys, :People, :Agreements]

    permissions = { }

    classes.each do |clazz|
      entity = clazz.to_s.singularize.downcase
      permissions[entity] = {}
      policy =  Pundit.policy(person, clazz)
      policy.public_methods(false).sort.each do |m|
        result = policy.send m
        op = m.to_s.gsub(/\?$/, '')
        permissions[entity][op] = result
      end

      super_policy = policy.class.superclass.new(person, clazz)
      super_policy.public_methods(false).sort.each do |m|
        result = policy.send m
        op = m.to_s.gsub(/\?$/, '')
        permissions[entity][op] = result
      end
    end

    permissions
  end
end
