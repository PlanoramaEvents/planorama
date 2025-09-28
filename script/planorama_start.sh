#!/usr/bin/env sh
# inspired by the start script  from Matthew's wellington code

export NODE_ENV=${RAILS_ENV}

# Development environment setup runs when RAILS_ENV is not set
if [[ -z $RAILS_ENV ]] || [[ $RAILS_ENV = "development" ]]; then
  gem install bundler:2.3.26
  bin/bundle install --quiet

  # Install JS modules
  bin/vite install

  bin/rake db:db_missing || (bin/rails db:create; bin/rails db:schema:load)

  # bin/rails db:structure:load
  bin/rake views:recreate
  bin/rake db:migrate
  bin/rake parameters:seed_names
  bin/rake role_types:seed_role_types
  # bin/rake chicon:seed_exclusions
  # bin/rake chicon:seed_room_sets
  # bin/rake chicon:seed_rooms
  # bin/rake chicon:fix_formats
  # bin/rake chicon:init_age_restrictions
  # bin/rake chicon:map_session_to_exclusion
  bin/rake rbac:seed_defaults

  # Run migrations and start the server, anything that comes in on 3000 is accepted
  # bin/rails db:create
  bin/rails db:seed
elif [[ $RAILS_ENV = "staging" ]]; then
  export RAILS_SERVE_STATIC_FILES=true
  bin/rake db:db_missing || (bin/rails db:create; bin/rails db:structure:load)

  bin/rake db:migrate
  bin/rake views:recreate
  bin/rake parameters:seed_names
  bin/rake role_types:seed_role_types
  # bin/rake chicon:seed_exclusions
  # bin/rake chicon:seed_room_sets
  # bin/rake chicon:seed_rooms
  # bin/rake chicon:fix_formats
  # bin/rake chicon:init_age_restrictions
  # bin/rake chicon:map_session_to_exclusion
  bin/rake rbac:seed_defaults

  bin/rails db:seed

  bin/rake assets:precompile
else
  export RAILS_SERVE_STATIC_FILES=true
  until psql -Atx "postgresql://$POSTGRES_USER:$POSTGRES_PASSWORD@$DB_HOST" -c 'select current_date'; do
    echo "waiting for postgres..."
    sleep 5
  done

  bin/rake db:db_missing || (bin/rails db:create; bin/rails db:structure:load)

  bin/rake db:migrate
  bin/rake views:recreate
  bin/rake parameters:seed_names
  bin/rake role_types:seed_role_types
  # bin/rake chicon:seed_exclusions
  # bin/rake chicon:seed_room_sets
  # bin/rake chicon:seed_rooms
  # bin/rake chicon:fix_formats
  # bin/rake chicon:init_age_restrictions
  # bin/rake chicon:map_session_to_exclusion
  bin/rake rbac:seed_defaults

  bin/rake assets:precompile
fi

if [[ -z $RAILS_ENV ]] || [[ $RAILS_ENV = "development" ]]; then
  bin/dev
else
  bin/rails server -b 0.0.0.0
fi
