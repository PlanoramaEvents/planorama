# We want to get a list of the policies for a user
module PolicyService
  def self.policies_for(person:)
    classes = [:Submissions, :Surveys, :People, :Agreements]

    permissions = { }

    classes.each do |clazz|
      permissions["#{clazz}"] = {}
      policy =  Pundit.policy(person, clazz)
      policy.public_methods(false).sort.each do |m|
        result = policy.send m
        op = m.to_s.gsub(/\?$/, '')
        permissions["#{clazz}"][op] = result
      end
    end

    permissions
  end
end
