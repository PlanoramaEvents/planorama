#!/usr/bin/env sh
# Based on the script from wellingtom

# Wait for postgres opens it's ports to start services
if [[ -z $DB_HOST ]]; then
  DB_HOST="postgres"
fi

if [[ -z $DB_NAME ]]; then
    DB_NAME="planorama_production"
fi

until psql -Atx "postgresql://$POSTGRES_USER:$POSTGRES_PASSWORD@$DB_HOST/$DB_NAME" -c 'select current_date'; do
  echo "waiting for postgres..."
  sleep 5
done

# Development environment setup runs when RAILS_ENV is not set
if [[ -z $RAILS_ENV ]]; then
  bundle install --quiet
  yarn install --frozen-lockfile
  bin/rake dev:bootstrap
  bin/rails webpacker:install -n

  # Background webpack watcher for speedy complilation
  # FIXME Hack, should be it's own process but was done this way so rails doesn't hit webpacker as well
  bin/webpack-dev-server --host 0.0.0.0 &
fi

# Run migrations and start the server, anything that comes in on 3000 is accepted
bin/rake db:migrate
bin/rails server -b 0.0.0.0
