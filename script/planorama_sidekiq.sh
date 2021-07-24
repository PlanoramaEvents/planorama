#!/usr/bin/env sh
# inspired by the start script  from Matthew's wellington code

# Development environment setup runs when RAILS_ENV is not set
if [[ -z $RAILS_ENV ]] || [[ $RAILS_ENV = "development" ]]; then
  gem install bundler:2.2.4
  bin/bundle install --quiet
fi

# TODO: assets ???

bundle exec sidekiq
