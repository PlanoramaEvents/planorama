after :person do

    if !Person.find_by(name: 'test')
        p = Person.create(
            name: 'test',
            password: 111111
            # confirmed_at: Time.now
        )

        EmailAddress.create(
            person: p,
            isdefault: true,
            email: 'test@test.com',
            is_valid: true
        )

        PersonRole.create(
          person: p,
          role: PersonRole.roles[:admin]
        )
    end

    if !Person.find_by(name: 'staff')
        p = Person.create(
            name: 'staff',
            password: 111111
            # confirmed_at: Time.now
        )

        EmailAddress.create(
            person: p,
            isdefault: true,
            email: 'staff@test.com',
            is_valid: true
        )

        PersonRole.create(
          person: p,
          role: PersonRole.roles[:planner]
        )
    end

    if !Person.find_by(name: 'participant')
        p = Person.create(
            name: 'participant',
            password: 111111
            # confirmed_at: Time.now
        )

        EmailAddress.create(
            person: p,
            isdefault: true,
            email: 'participant@test.com',
            is_valid: true
        )

        PersonRole.create(
          person: p,
          role: PersonRole.roles[:member]
        )
    end

    p "Created special test users for development environment."


end
