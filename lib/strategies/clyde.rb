# frozen_string_literal: truejson,
require 'omniauth-oauth2'

# Minimal OAuth Strategy used to authenticate with Clyde
module OmniAuth
  module Strategies
    class Clyde < OmniAuth::Strategies::OAuth2
      option :name, 'clyde'
      option :provider_ignores_state, true

      # get URL from settings in DB ...
      # done by over-riding the client method and making the site option
      # dyanmic based on the value from the ClydeService
      def client
        opt = deep_symbolize(options.client_options)
        opt[:site] = ::ClydeService.base_url
        # The token endpoint was changed ...
        opt[:token_url] = "#{opt[:site]}/api/v1/oauth/token"

        ::OAuth2::Client.new(options.client_id, options.client_secret, opt)
      end

      private
      def callback_url
        full_host + callback_path
      end
    end
  end
end
