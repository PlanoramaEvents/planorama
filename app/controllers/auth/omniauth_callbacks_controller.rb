#
module Auth
  class OmniauthCallbacksController < ApplicationController
    skip_before_action :authenticate_person!

    #
    def create
      # Get the credentials from the response
      auth_info = request.env["omniauth.auth"]
      provider = auth_info[:provider]

      # Get the Identity based on the Oauth service
      # Add in other cases as they are created
      identity = if provider == 'clyde'
                   IdentityService.from_clyde(auth_info: auth_info)
                 end

      # sign in as the person for Plano
      sign_in identity.person if identity&.person

      redirect_to '/' # Got to the home page/dashboard
    end
  end
end
