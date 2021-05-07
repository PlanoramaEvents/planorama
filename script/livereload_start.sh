#!/usr/bin/env sh
gem install bundler:2.2.4
bin/bundle install --quiet
bundle exec guard -iP livereload
