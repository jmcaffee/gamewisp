##############################################################################
# File::    authorizer.rb
# Purpose:: Gamewisp OAuth Authorizer
# 
# Author::    Jeff McAffee 11/07/2016
# Copyright:: Copyright (c) 2016, kTech Systems LLC. All rights reserved.
# Website::   http://ktechsystems.com
##############################################################################

require 'json/pure'
require 'httparty'

module Gamewisp
  class Authorizer

    attr_accessor :token_store
    attr_accessor :gamewisp_url
    attr_accessor :authorize_path
    attr_accessor :redirect_uri
    attr_accessor :host
    attr_accessor :port
    attr_accessor :scopes
    attr_accessor :state


    # Only works if this class is derived (includes) HTTParty
    #
    #if ENV["DEBUG"]
    #  debug_output $stdout
    #end

    def initialize state, store
      self.token_store = store

      self.gamewisp_url = 'api.gamewisp.com'
      self.authorize_path = "/pub/v1/oauth/authorize"
      self.host = token_store.endpoint_host
      self.port = token_store.endpoint_port
      self.redirect_uri = "http://#{host}:#{port}"

      self.scopes = "read_only,subscriber_read_full,user_read"
      self.state = state
    end

    def app_authorization_url
      params = {
        response_type: "code",
        client_id: token_store.client_id,
        redirect_uri: redirect_uri,
        scope: scopes,
        state: state,
      }

      url = {
        host: gamewisp_url,
        path: authorize_path,
        query: URI.encode_www_form(params)
      }

      return URI::HTTPS.build(url)
    end

    def create_server_instance
      return Server.new(port, state)
    end

    def renew_tokens_with_auth_code code
      response = get_new_tokens_using_auth_code code
      dbg("renew_tokens_with_auth_code", response)
      if response.code == 200
        token_store.save_access_token response["access_token"]
        token_store.save_refresh_token response["refresh_token"]
      else
        puts "Errors have occured during authentication code request:"
        puts response
      end
    end

    def renew_tokens_with_refresh_token token
      response = get_new_tokens_using_refresh_token token
      dbg("renew_tokens_with_refresh_token", response)
      if response.code == 200
        token_store.save_access_token response["access_token"]
        token_store.save_refresh_token response["refresh_token"]
      else
        puts "Errors have occured during token refresh request:"
        puts response
      end
    end

    def get_new_tokens_using_auth_code code
      url = "https://#{gamewisp_url}/pub/v1/oauth/token"

      response = HTTParty.post(url,
                  :query => {
                    :grant_type => 'authorization_code',
                    :client_id => token_store.client_id,
                    :client_secret => token_store.client_secret,
                    :redirect_uri => redirect_uri,
                    :code => code,
                    :state => state,
                  })
      return {:error => "#{response.code}: authorization error"} if response.code == 401

      return response
    end

    def get_new_tokens_using_refresh_token token
      url = "https://#{gamewisp_url}/pub/v1/oauth/token"

      # For some reason we have to post in the :body instead of :query (as above) or we'll
      # get an 'invalid refresh token' error response.
      #
      response = HTTParty.post(url,
                  :body => {
                    :grant_type => 'refresh_token',
                    :client_id => token_store.client_id,
                    :client_secret => token_store.client_secret,
                    :redirect_uri => redirect_uri,
                    :refresh_token => token,
                  })

      return {:error => "#{response.code}: authorization error"} if response.code == 401

      return response
    end
  end
end # module
