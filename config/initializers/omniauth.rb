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
# So dev is forced to use the error path that other envs will have
OmniAuth.config.failure_raise_out_environments = []
