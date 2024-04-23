source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.1' #, '>= 6.0.3.2'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'

gem 'activerecord-postgres_enum'
gem 'actionpack-action_caching'

# Use Puma as the app server
gem 'puma', '>= 5.0'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 5.0'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
gem "recaptcha"

gem "bundler-audit"        # checks for insecure gems

gem 'composite_primary_keys', '~> 13.0' # Version 13.x is designed to work with ActiveRecord 6.1.x

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false

gem 'acts-as-taggable-on', '~> 9.0'
gem 'kaminari'
gem 'active_model_serializers', '~> 0.10.0'

gem 'aasm'

gem 'devise'
# gem 'omniauth'
gem "omniauth-rails_csrf_protection"
gem 'omniauth-oauth2'

gem 'with_advisory_lock'

gem 'pwned'
# gem 'devise-jwt'
gem 'rack-cors'
gem 'request_store'

gem 'ranked-model'
gem "nilify_blanks"
gem 'paper_trail'
gem 'pundit'

gem "sidekiq"
gem "sidekiq-scheduler"
gem 'io-wait'
gem 'fast_excel'
gem 'ransack'
gem 'jsonapi-serializer'
gem 'jsonapi.rb'

gem 'deep_cloneable', '~> 3.2.0'

gem "nokogiri", ">= 1.13"
gem "roo", "~> 2.8.0"

gem 'truemail'
gem "net-http"

# This is needed to run the migrations from id to uuid for primary keys
gem 'webdack-uuid_migration'

# for integrations!
gem "httparty"
gem "json-diff"

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem "brakeman"                                      # vulnerability and static analysis
  gem "ruby_audit"                                    # checks for CVEs affecting Ruby and RubyGems
end

group :staging, :development, :test do
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'seedbank'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  # upgrade sprint to 3.0 ...
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'rubocop'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
  gem 'guard'
  gem 'guard-livereload'
  gem 'rack-livereload'
  gem 'annotate'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
  # testing using rspec and factory bot
  gem 'rspec'
  gem 'rspec-rails'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
