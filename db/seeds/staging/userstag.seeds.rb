if !Person.find_by(name: 'chicon admin')
    p = Person.create(
        name: 'chicon admin',
        password: 321321
    )

    EmailAddress.create(
        person: p,
        isdefault: true,
        email: 'chiconadmin@test.com',
        is_valid: true
    )

    PersonRole.create(
        person: p,
        role: PersonRole.roles[:admin]
    )
  
end


p "Created special admin user for staging environment."
