require 'strategies/clyde'

Rails.application.config.middleware.use OmniAuth::Builder do
  # provider :developer unless Rails.env.production?
  provider :clyde, 
            ENV["OAUTH_CLYDE_ID"],
            ENV["OAUTH_CLYDE_SECRET"],
            scope: 'view-participant'
end

OmniAuth.config.logger = Rails.logger
OmniAuth.config.path_prefix = '/auth'
