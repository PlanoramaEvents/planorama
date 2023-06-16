# frozen_string_literal: truejson,
require 'omniauth-oauth2'

# Minimal OAuth Strategy used to authenticate with Clyde
module OmniAuth
  module Strategies
    class Clyde < OmniAuth::Strategies::OAuth2
      option :name, 'clyde'
      option :provider_ignores_state, true

      def token_params
        params = super
        params[:headers] ||= {}
        # Header needs a base64 encode Auth string
        params[:headers][:Authorization] = format('Basic %s', Base64.strict_encode64("#{client.id}:#{client.secret}"))
        params
      end

      # get URL from settings in DB ...
      # done by over-riding the client method and making the site option
      # dyanmic based on the value from the ClydeService
      def client
        opt = deep_symbolize(options.client_options)
        opt[:site] = ::ClydeService.base_url

        ::OAuth2::Client.new(options.client_id, options.client_secret, opt)
      end

      private
      def callback_url
        full_host + callback_path
      end
    end
  end
end
