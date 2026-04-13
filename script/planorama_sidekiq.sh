#!/usr/bin/env sh
# inspired by the start script  from Matthew's wellington code

export NODE_ENV=${RAILS_ENV}

# Development environment setup runs when RAILS_ENV is not set
if [[ -z $RAILS_ENV ]] || [[ $RAILS_ENV = "development" ]]; then
  gem install bundler:2.3.26
  bin/bundle install --quiet
  yarn install
else
  until psql -Atx "postgresql://$POSTGRES_USER:$POSTGRES_PASSWORD@$DB_HOST/$DB_NAME" -c 'select current_date'; do
    echo "waiting for postgres..."
    sleep 5
  done
fi

bundle exec sidekiq
