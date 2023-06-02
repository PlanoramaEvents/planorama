# frozen_string_literal: truejson,
require 'omniauth-oauth2'

# Minimal OAuth Strategy used to authenticate with Clyde
module OmniAuth
  module Strategies
    class Clyde < OmniAuth::Strategies::OAuth2
      option :name, 'clyde'
      # TODO: get URL from settings in DB ...
      option :client_options, { site: 'https://worldcon.staxotest.net' }
      option :provider_ignores_state, true

      def token_params
        params = super
        params[:headers] ||= {}
        # Header needs a base64 encode Auth string
        params[:headers][:Authorization] = format('Basic %s', Base64.strict_encode64("#{client.id}:#{client.secret}"))
        params
      end

      private
      def callback_url
        full_host + callback_path
      end
    end
  end
end
