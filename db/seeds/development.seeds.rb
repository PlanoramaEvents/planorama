#
#
#
if User.count == 0
  # create an initial 'test' user to get things going for dev
  User.create(
    username: 'test',
    email: 'test@chicon.org',
    password: 111111,
    confirmed_at: Time.now
  )
end

if UserRole.count == 0
  UserRole.create(
    title: 'admin'
  )
end

if UserRoleAssignment.count == 0
  user = User.find_by(username: 'test')
  role = UserRole.find_by(title: 'admin')
  UserRoleAssignment.create(
    user: user,
    user_role: role
  )
end

if Person.count == 0
  100.times.each do |i|
    Person.create(
      first_name: Faker::Name.unique.first_name,
      last_name: Faker::Name.unique.last_name
    )
  end
end
