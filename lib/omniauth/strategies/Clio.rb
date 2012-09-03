require 'omniauth-oauth'
require 'multi_json'

module OmniAuth
  module Strategies
    class Clio < OmniAuth::Strategies::OAuth
      option :name, 'clio'
      option :client_options, {:site => 'https://app.goclio.com/'}

      uid { raw_info['email'] }

      info do
        {
          :email => raw_info['email'],
          :last_name => raw_info['last_name'],
          :first_name => raw_info['first_name']
        }
      end

      extra do
        { :raw_info => raw_info }
      end

      def raw_info
        @raw_info ||= MultiJson.load(access_token.get('/1/account/verify_credentials.json').body)
      rescue ::Errno::ETIMEDOUT
        raise ::Timeout::Error
      end

      alias :old_request_phase :request_phase

      def request_phase
        force_login = session['omniauth.params'] ? session['omniauth.params']['force_login'] : nil
        screen_name = session['omniauth.params'] ? session['omniauth.params']['screen_name'] : nil
        x_auth_access_type = session['omniauth.params'] ? session['omniauth.params']['x_auth_access_type'] : nil
        if force_login && !force_login.empty?
          options[:authorize_params] ||= {}
          options[:authorize_params].merge!(:force_login => 'true')
        end
        if screen_name && !screen_name.empty?
          options[:authorize_params] ||= {}
          options[:authorize_params].merge!(:force_login => 'true', :screen_name => screen_name)
        end
        if x_auth_access_type
          options[:request_params] || {}
          options[:request_params].merge!(:x_auth_access_type => x_auth_access_type)
        end

        if session['omniauth.params'] && session['omniauth.params']["use_authorize"] == "true"
          options.client_options.authorize_path = '/oauth/authorize'
        else
          options.client_options.authorize_path = '/oauth/authenticate'
        end
        
        old_request_phase
      end

    end
  end
end
