
if !Person.find_by(last_name: 'staff')
    p = Person.create(
        first_name: 'test',
        last_name: 'staff',
        password: 111111
        # confirmed_at: Time.now
    )

    EmailAddress.create(
        person: p,
        isdefault: true,
        email: 'staff@test.com',
        is_valid: true
    )

end

if !Person.find_by(last_name: 'participant')
    p = Person.create(
        first_name: 'test',
        last_name: 'participant',
        password: 111111
        # confirmed_at: Time.now
    )

    EmailAddress.create(
        person: p,
        isdefault: true,
        email: 'participant@test.com',
        is_valid: true
    )

end

#TODO: Add roles when we get around to them

p "Created special test user for test environment."

