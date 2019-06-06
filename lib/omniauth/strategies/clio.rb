require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Clio < OmniAuth::Strategies::OAuth2
      option :name, "clio"

      option :client_options, {
          :site => 'https://app.clio.com',
          :authorize_url => '/oauth/authorize',
          :token_url => '/oauth/token'
      }

      uid { raw_info['data']['id']}

      info do
        {
            :last_name => raw_info['data']['last_name'],
            :first_name => raw_info['data']['first_name'],
            :email => raw_info['data']['email']
        }
      end
      
      extra do
        {:raw_info => raw_info}
      end

      def callback_url
        full_host + script_name + callback_path
      end 
       
      def raw_info
        @raw_info ||= access_token.get('/api/v4/users/who_am_i', params: { fields: 'id,last_name,first_name,email' }).parsed
      end
    end
  end
end
