#!/usr/bin/env sh
# inspired by the start script  from Matthew's wellington code

# Development environment setup runs when RAILS_ENV is not set
if [[ -z $RAILS_ENV ]]; then
  bin/bundle install --quiet
  bin/yarn install
  # bin/rake dev:bootstrap

  # Background webpack watcher for speedy complilation
  # FIXME Hack, should be it's own process but was done this way so rails doesn't hit webpacker as well
  bin/webpack-dev-server --host 0.0.0.0 &
fi

# Run migrations and start the server, anything that comes in on 3000 is accepted
bin/rails db:create
bin/rails db:schema:load
bin/rake db:migrate
bin/rails db:seed
bin/rails server -b 0.0.0.0

# bin/rake db:migrate
# bin/rails server -b 0.0.0.0
