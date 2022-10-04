# Worldcon Programme Planning System
![Production version](https://img.shields.io/github/v/release/ChicagoWorldcon/planorama?label=production)
![Staging version](https://img.shields.io/github/v/release/ChicagoWorldcon/planorama?include_prereleases&label=staging)

# Getting Started

## Configuration

Rails 6.x
Vue.js

## Note On Local Development

## Set up your environment

Apart from GIT and whatever IDE/editor you prefer to use the minimum to
run a dev env is docker desktop.

You will need to create a `.envrc` file. The minimal contant should have

```
export POSTGRES_USER=yourdbuser
export POSTGRES_PASSWORD=yourpassword
export DEVISE_SECRET=abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz
export SIDEKIQ_REDIS_URL=redis://localhost:6379/0
export SMTP_PORT=10025
export SMTP_SERVER=127.0.0.1
export HOSTNAME=localhost
export HOSTPORT=3000
export PROGRAM_EMAIL=planorama@mycon.org
```

The USER and PASSWORD will be used by the docker scripts to create an instance of the database
and set up an initial user. Also by the Rails database.yml for the connection. Their value is
unimportant and can be used as-is.

DEVISE_SECRET is used by Ruby for encryption. Any long string will do. This one works fine.

Redis is running in a container, so Sidekiq and Rails needs to be told where it is.

If you are installing this on a Windows machine, you may need to run the
following command:

```
git config --global core.autocrlf input
```

The dev docker compose uses external volumes so that we can persist data
between runs. These are created using the following:

```
docker volume create --name=pgdata
docker volume create --name=redis-data
docker volume create --name=node_modules
docker volume create --name=node_modules_sidekiq
```

Then to start the dev docker instances use

```
docker-compose -f docker-compose-dev.yml up
```

alternatively use
```
rake docker:start

# and to stop them
rake docker:stop
```

You will be able to access the running server via http://localhost:3000 and
a test user will available (test@test.com with password 111111)

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

## Mailings

To see mail sent by the dev environment, navigate in your browser to http://localhost:1080.

(If this doesn't work, try restarting your development environment.)

## Deployment/Build issues

Two of us have seen this error while doing the `docker-compose` build in development.
```
error "@storybook/addon-essentials#@storybook/addon-docs#@storybook/builder-webpack4#postcss-loader#schema-utils#@types/json-schema" is wrong version: expected "^7.0.8", got "7.0.7"
```

There are also some yarn messages about it being out of date. The fix seems to be to delete the docker volumes used by yarn. These can be deleted from the docker client or the command line. I'll give the commandline instructions and you can figure out the equivalent instructions in the client.

Before you can delete the volumes, you have to delete the container that references them. You don't have to delete all the images, just the container.

`docker container prune`

You'll be asked if you really want to delete all stopped containers.

Now you can delete the volumes. You have to manually recreate them before you can build again.

```
docker volume rm node_modules node_modules_sidekiq
docker volume create --name=node_modules
docker volume create --name=node_modules_sidekiq
```

Now you can run `docker-compose`

# Notes for Production

There is a sample docker compose file `docker-compose-prod.yml` that can be used to base a prodction instance on. It assumes
that the Postgres DB is running outside of docker. If you want to run the DB in a container have a look at the Staging
compose file for an example of how that is done.

There are automated builds happening in Github and docker containers are stored in the Github repo. One for each branch (main, staging, development)
as well as a "latest" which is built when a release tag is done. To pull them use one of the following commands:

```
docker pull ghcr.io/chicagoworldcon/planorama:main
docker pull ghcr.io/chicagoworldcon/planorama:staging
docker pull ghcr.io/chicagoworldcon/planorama:development
docker pull ghcr.io/chicagoworldcon/planorama:latest
```

Latest will be the last build based on a tagged release.

## Directory mappings

We map the log directories from the containers to teh system directories `/var/log/planorama/web` and `/var/log/planorama/sidekiq`,
see the mapping under the web and sidekiq containers, they have a line like the following to do the mapping:

```
  - /var/log/planorama/web:/opt/planorama/log
```

## Redis data

Redis data needs to be persistent between runs of the docker container. You will need to create a volume using the
docker command as follows:

```
docker volume create --name=redis-data
```

## Environment

The containers rely on enironment variables. The docker file loads the environment from a file,
which is specified via a line as follows:

```
  - "/opt/chicago/etc/planorama.env"
```

change this to what is appropriate for your system.

The file should contain lines like the following with values appropriate to your
installation:

```
HOSTNAME=planorama.mycon.org
RAILS_ENV=production
RAILS_LOG_TO_STDOUT=true
RAILS_LOG_LEVEL=info

DEVISE_SECRET=

DB_HOST=
DB_NAME=
POSTGRES_USER=
POSTGRES_PASSWORD=

PROGRAM_EMAIL=program@mycon.org

SMTP_SERVER=
SMTP_PORT=
SMTP_USER_NAME=
SMTP_PASSWORD=

SIDEKIQ_REDIS_URL=redis://redis:6379/0
# the sidekiq user and password are optional
# SIDEKIQ_USER=sidekiq
# SIDEKIQ_PASSWORD=
```

Generate a secret key for devise using the following

```
bundle exec rake secret
```

and set that as the value for the env variable

## Event Settings

Once you have an instance running you will need to do the following

1. create an initial user
2. login and setup the event Settings

### Create initial user

You can run a shell in the rails docker container and create a user as follows:

Run a shell in the web docker container:
```
docker exec -it  planorama_web_1 sh
```

Run the rails console

```
bin/rails c
```

Create a person/user from within the rails console. Set the name, password and email to
match what you need:

```
p = Person.create(
  name: 'admin',
  password: 'StrongPassword'
)

EmailAddress.create(
  person: p,
  isdefault: true,
  email: 'admin@mycon.com',
  is_valid: true
)

ConventionRole.create(
  person: p,
  role: ConventionRole.roles[:admin]
)
```

### Event Settings

In the Admin page you will see an Event Settings panel, open that and set at least the following:

- Email From Address
- Email reply to Address
- Convention Timezone
- Convention start and end times
