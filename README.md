# Worldcon Programme Planning System

# Getting Started

## Configuration

Rails 6.x
Vue.js and vue-mc

### Devise
We are using encrypted secrets for now. For dev please request key file.

## Note On Local Development

## Set up your environment

Apart from GIT and whatever IDE/editor you prefer to use the minimum to
run a dev env is docker desktop.

You will need to create a `.envrc` file. The minimal contant should have

```
export POSTGRES_USER=yourdbuser
export POSTGRES_PASSWORD=yourpassword
```

This will be used by the docker scripts to create an instance of the database
and set up an initial user. Also by the Rails database.yml for the connection.

If you are installing this on a Windows machine, you may need to run the
following command:

```
git config --global core.autocrlf input
```

To start the dev docker instances use

```
docker-compose -f docker-compose.yml -f  docker-compose-dev.yml up
```

alternatively use
```
rake docker:start

# and to stop them
rake docker:stop
```

You will be able to access the running server via http://localhost:3000 and
a test user will available (test@test.com with password 111111)


NOTE: there is a encrypted key for devise (used for login). You will need
a copy of the `master.key` file. This is not in source code control. When you get it, move it to `config/master.key`

NOTE: the docker image will use the files from the project directory.
So editing those files will affect what is running in docker (and most
changes can be seen by refreshing the page you are working on)

## Running tests

Assuming you have your local environment going, the easiest way is to run them on docker:
```
docker exec planorama_planorama_1 bundle exec rspec
```

There is also a shortcut:
```
rake docker:test
```
