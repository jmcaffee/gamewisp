##############################################################################
# File::    client.rb
# Purpose:: Gamewisp API client library
# 
# Author::    Jeff McAffee 11/07/2016
# Copyright:: Copyright (c) 2016, kTech Systems LLC. All rights reserved.
# Website::   http://ktechsystems.com
##############################################################################

require 'json/pure'
require 'httparty'

module Gamewisp
  class Client

    attr_accessor :token_store
    attr_accessor :auth


    # Only works if this class is derived (includes) HTTParty
    #
    #if ENV["DEBUG"]
    #  debug_output $stdout
    #end

    def initialize
      self.token_store = TokenStore.new
      self.auth = Authorizer.new 'createauth'
    end

    def authorize
      puts "Visit the following URL in your browser and authorize #{token_store.app_name} to access your subscription metrics"
      puts "   #{auth.app_authorization_url}"
      puts

      server = auth.create_server_instance
      auth_result = server.get_authentication_token

      puts auth_result
      if auth_result["code"]
        puts "Authorization received"
      else
        raise GamewispError, "Authorization failed."
      end

      auth.renew_tokens_with_auth_code auth_result["code"]
    end

    def renew_access_token
      if token_store.refresh_token.nil? || token_store.refresh_token.empty?
        return authorize
      end

      auth.renew_tokens_with_refresh_token token_store.refresh_token
    end

    def get_subscribers
      url = "https://api.gamewisp.com/pub/v1/channel/subscribers"

      response = HTTParty
        .get(url,
            :query => {
              :access_token => token_store.access_token,
              :include => 'user,channel,benefits',
            }
          )

      response
    end
  end
end # module
