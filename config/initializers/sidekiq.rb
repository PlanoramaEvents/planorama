#
#
#
DEFAULT_REDIS_URL = "redis://planorama-redis:6379/0"
sidekiq_config = { url: ENV.fetch("SIDEKIQ_REDIS_URL", DEFAULT_REDIS_URL) }

Sidekiq.configure_server do |config|
  config.redis = sidekiq_config
end

Sidekiq.configure_client do |config|
  config.redis = sidekiq_config
end
