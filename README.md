# Worldcon Programme Planning System

# Getting Started

## Note On Local Development

## Set up your environment


--------------

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version
Ruby 2.6.x
* System dependencies

* Configuration
Rails 6
Vue.js`
vue-mc
* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
brew install postgresql
brew services start postgresql
psql postgres

bundle install
rake db:schema:load

bundle exec rails webpacker:install:vue
rails generate devise:install
rails generate devise User
yarn add vue-mc
yarn add bulma
yarn add buefy
yarn add vue-turbolinks
yarn add vue-router
yarn add @fortawesome/fontawesome-free
<!-- yarn add vue-sidebar-menu -->
<!-- yarn add vue-turbolinks -->
rails webpacker:install:erb
