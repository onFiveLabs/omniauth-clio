require 'omniauth-oauth2'
require 'multi_json'

module OmniAuth
  module Strategies
    class Clio < OmniAuth::Strategies::OAuth2
      option :name, "clio"

      option :client_options, {
        :site => 'https://app.goclio.com',
        :authorize_url => '/oauth/authorize',
        :token_url => '/oauth/token'
      }
      
      uid { raw_info['user']['id']}

      info do
        {
          :last_name => raw_info['user']['last_name'],
          :first_name => raw_info['user']['first_name'],
          :email => raw_info['user']['email'],
          :firm => raw_info['account']['name'],
        }
      end

      def authorize_params
        super.tap do |params|
          params[:response_type] = "code"
          params[:client_id] = client.id
          params[:redirect_uri] ||= callback_url
        end
      end

      def request_phase
        super
      end

      def build_access_token
        token_params = {
          :code => request.params['code'],
          :redirect_uri => callback_url,
          :client_id => client.id,
          :client_secret => client.secret,
          :grant_type => 'authorization_code'
        }
        client.get_token(token_params)
      end

      extra do
        {:raw_info => raw_info}
      end

      def raw_info
        @raw_info ||= MultiJson.load(access_token.get('/api/v1/users/who_am_i').body)
      rescue ::Errno::ETIMEDOUT
        raise ::Timeout::Error
      end
    end
  end
end

