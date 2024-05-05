#
module Auth
  class OmniauthCallbacksController < ApplicationController
    skip_before_action :authenticate_person!

    #
    def create
      # Get the credentials from the response
      auth_info = request.env["omniauth.auth"]
      provider = auth_info[:provider]

      # Get the redirect from the oauth parameters
      # which are passed through
      oauth_params = request.env["omniauth.params"]
      redirect = oauth_params['redirect']

      # Get the Identity based on the Oauth service
      # Add in other cases as they are created
      identity = if provider == 'clyde'
                   IdentityService.from_clyde(auth_info: auth_info, current_person: current_person)
                  end

      # sign in as the person for Plano
      sign_in identity.person if !current_person && identity&.person

      if !redirect.blank?
        redirect_to "/##{redirect}"
      else
        redirect_to '/' # Got to the home page/dashboard
      end
    rescue Exceptions::AuthError => e
      redirect_to "/#error/#{e.code}"
    end

    def failure
      # Direct to an actual error page, as we can get here via link as well
      # and we are already logged in
      redirect_to "/#error/100" # Got to the error screen
    end
  end
end
