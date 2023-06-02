#
module Auth
  class OmniauthCallbacksController < ApplicationController

    skip_before_action :authenticate_person!

    #
    def create
      # Get the credentials from the response
      auth_info = request.env["omniauth.auth"]
      credentials = auth_info[:credentials]

      # Get Participant Details
      # TODO: maybe we want to pass refresh token, but time should not be that long...
      svc = ClydeService.get_svc(access_token: credentials[:token])
      details = svc.my_details

      # Create or find the Identity
      # associate with Person and authenticate
      identity = OauthIdentity.from_omniauth(provider: 'clyde', details: details['data'])

      # sign in as the person for Plano
      sign_in identity.person if identity.person

      # TODO: .... check
      redirect_to '/'
    end
  end
end
