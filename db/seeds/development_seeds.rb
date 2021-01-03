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

# todo - add role
