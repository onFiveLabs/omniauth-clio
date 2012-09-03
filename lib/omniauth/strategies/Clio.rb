require 'omniauth-oauth'
# require 'multi_json'

module OmniAuth
  module Strategies
    class Clio < OmniAuth::Strategies::OAuth2
      option :client_options, {
        :site => 'https://app.goclio.com',
        :authorize_url => 'https://app.goclio.com/oauth/authorize',
        :token_url => 'https://app.goclio.com/oauth/access_token'
      }

      def request_phase
        options[:scope] ||= 'basic'
        options[:response_type] ||= 'code'
        super
      end

      uid { raw_info['id'] }

      info do
        {
          'name'     => raw_info['full_name'],
          'website'  => raw_info['website'],
        }
      end

      def raw_info
        @data ||= access_token.params["user"]
      end

    end
  end
end
