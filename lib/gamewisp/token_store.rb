##############################################################################
# File::    token_store.rb
# Purpose:: Store Gamewisp OAuth Tokens and authenication info
# 
# Author::    Jeff McAffee 11/07/2016
# Copyright:: Copyright (c) 2016, kTech Systems LLC. All rights reserved.
# Website::   http://ktechsystems.com
##############################################################################

module Gamewisp
  class TokenStore

    def initialize
      @tokens = {
        :access_token => '',
        :refresh_token => '',
      }

      read_token_file
    end

    def client_id
      id = ENV["GAMEWISP_ID"]
      id ||= Gamewisp.configuration.client_id
    end

    def client_secret
      secret = ENV["GAMEWISP_SECRET"]
      secret ||= Gamewisp.configuration.client_secret
    end

    def app_name
      name = ENV["GAMEWISP_APP"]
      name ||= Gamewisp.appname
    end

    def endpoint_host
      host = ENV["GAMEWISP_ENDPOINT_HOST"]
      host ||= Gamewisp.configuration.endpoint_host
    end

    def endpoint_port
      port = ENV["GAMEWISP_ENDPOINT_PORT"]
      port ||= Gamewisp.configuration.endpoint_port
    end

    def save_access_token token
      @tokens[:access_token] = token
      write_token_file
    end

    def save_refresh_token token
      @tokens[:refresh_token] = token
      write_token_file
    end

    def access_token
      @tokens[:access_token]
    end

    def refresh_token
      @tokens[:refresh_token]
    end

    def token_file_path
      filedir = "#{ENV['HOME']}/.gamewisp"
      filepath = File.join(filedir, "tokens.yml")

      unless File.exist?(filedir)
        FileUtils.mkdir_p filedir
      end

      filepath
    end

    def write_token_file
      filepath = token_file_path

      File.open(filepath, 'w') do |out|
        YAML.dump(@tokens, out)
      end
    end

    def read_token_file
      filepath = token_file_path

      if File.exist? filepath
        @tokens = YAML.load_file(filepath)
      end
    end
  end
end
