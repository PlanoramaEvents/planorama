# Worldcon Programme Planning System

# Getting Started

## Configuration

Rails 6.x
Vue.js

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
export DEVISE_SECRET=abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz
export SIDEKIQ_REDIS_URL=redis://localhost:6379/0
```

The USER and PASSWORD will be used by the docker scripts to create an instance of the database
and set up an initial user. Also by the Rails database.yml for the connection. Their value is
unimportant and can be used as-is.

DEVISE_SECRET is used by Ruby for encryption. Any long string will do. This one works fine.

Redis is not running at the default port, so Sidekiq needs to be told where it is.


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
