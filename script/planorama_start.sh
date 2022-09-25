#!/usr/bin/env sh
# inspired by the start script  from Matthew's wellington code

export NODE_ENV=${RAILS_ENV}

# Development environment setup runs when RAILS_ENV is not set
if [[ -z $RAILS_ENV ]] || [[ $RAILS_ENV = "development" ]]; then
  gem install bundler:2.2.4
  bin/bundle install --quiet

  # Do not let Yarn change versions of modules (causes problems of we do)
  bin/yarn install --frozen-lockfile
  # --check-files

  # NOTE: I moved node_modules to /tmp/node_modules and have a problem with
  # the webpacker dev server ... TODO to fix

  # It just put the load on rails for now (which still works)
  bin/rails webpacker:install -n

  # Background webpack watcher for speedy complilation
  # FIXME Hack, should be it's own process but was done this way so rails doesn't hit webpacker as well
  bin/webpack-dev-server --host 0.0.0.0 &

  bin/rake db:db_missing || (bin/rails db:create; bin/rails db:structure:load)

  # bin/rails db:structure:load
  bin/rake views:recreate
  bin/rake db:migrate
  bin/rake parameters:seed_names
  bin/rake role_types:seed_role_types
  bin/rake arisia:seed_exclusions
  bin/rake arisia:seed_room_sets
  bin/rake arisia:seed_rooms
  bin/rake arisia:fix_formats
  bin/rake arisia:init_age_restrictions
  bin/rake arisia:map_session_to_exclusion
  bin/rake rbac:seed_defaults

  # Run migrations and start the server, anything that comes in on 3000 is accepted
  # bin/rails db:create
  bin/rails db:seed
elif [[ $RAILS_ENV = "staging" ]]; then
  bin/rake db:db_missing || (bin/rails db:create; bin/rails db:structure:load)

  bin/rake views:recreate
  bin/rake db:migrate
  bin/rake parameters:seed_names
  bin/rake role_types:seed_role_types
  bin/rake arisia:seed_exclusions
  bin/rake arisia:seed_room_sets
  bin/rake arisia:seed_rooms
  bin/rake arisia:fix_formats
  bin/rake arisia:init_age_restrictions
  bin/rake arisia:map_session_to_exclusion
  bin/rake rbac:seed_defaults

  bin/rails db:seed
else
  until psql -Atx "postgresql://$POSTGRES_USER:$POSTGRES_PASSWORD@$DB_HOST/$DB_NAME" -c 'select current_date'; do
    echo "waiting for postgres..."
    sleep 5
  done

  bin/rake db:db_missing || (bin/rails db:create; bin/rails db:structure:load)

  bin/rake views:recreate
  bin/rake db:migrate
  bin/rake parameters:seed_names
  bin/rake role_types:seed_role_types
  bin/rake arisia:seed_exclusions
  bin/rake arisia:seed_room_sets
  bin/rake arisia:seed_rooms
  bin/rake arisia:fix_formats
  bin/rake arisia:init_age_restrictions
  bin/rake arisia:map_session_to_exclusion
  bin/rake rbac:seed_defaults
fi

bin/rails server -b 0.0.0.0
