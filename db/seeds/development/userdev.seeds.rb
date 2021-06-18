after :person do

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

    p "Created special test users for development environment."


end


