source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.3', '>= 6.0.3.2'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'

gem 'activerecord-postgres_enum'

# Use Puma as the app server
gem 'puma', '>= 4.3'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'

gem "bundler-audit"        # checks for insecure gems

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

gem 'acts-as-taggable-on', '~> 6.0'
gem 'kaminari'
gem 'active_model_serializers', '~> 0.10.0'

gem 'devise'
# gem 'devise-jwt'
gem 'rack-cors'

gem 'ranked-model'
gem "nilify_blanks"
gem 'paper_trail'
gem 'pundit'

gem "sidekiq"
gem "sidekiq-scheduler"
gem 'io-wait'
gem 'fast_excel'
gem 'jsonapi-serializer'
gem 'jsonapi.rb'

gem "nokogiri", ">= 1.12.5"

gem 'truemail'

# This is needed to run the migrations from id to uuid for primary keys
gem 'webdack-uuid_migration'

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
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'rubocop'
  gem 'guard'
  gem 'guard-livereload'
  gem 'rack-livereload'
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
