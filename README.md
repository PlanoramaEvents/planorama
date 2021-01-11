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

To start the dev docker instances use

```
docker-compose -f docker-compose.yml -f  docker-compose-dev.yml up
```

You will be able to access the running server via http://localhost:3000 and
a test user will available (test with password 111111)


NOTE: the docker image will use the files from the project directory.
So editing those files will affect what is running in docker (and most
changes can be seen by refreshing the page you are working on)
