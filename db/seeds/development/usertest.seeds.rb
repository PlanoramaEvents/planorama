
if !Person.find_by(last_name: 'test')
    p = Person.create(
        first_name: 'test',
        last_name: 'test',
        password: 111111
        # confirmed_at: Time.now
    )

    EmailAddress.create(
        person: p,
        isdefault: true,
        email: 'test@test.com',
        is_valid: true
    )
end

p "Created special test user for development."

