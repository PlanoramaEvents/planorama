require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Planorama
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Disable asset pipeline, should all be moved to webpacker now
    # config.assets.enabled = false
    # config.generators { |g| g.assets false }

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    if !Rails.env.test?
      config.active_job.queue_adapter = :sidekiq
    end

    config.active_record.schema_format = :sql
  end
end
