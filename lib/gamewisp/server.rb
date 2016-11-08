##############################################################################
# File::    server.rb
# Purpose:: Simple server to collect authentication token
# 
# Author::    Jeff McAffee 11/07/2016
# Copyright:: Copyright (c) 2016, kTech Systems LLC. All rights reserved.
# Website::   http://ktechsystems.com
##############################################################################

require 'socket'

module Gamewisp
  class Server

    attr_reader :port
    attr_reader :state

    def initialize port, state
      @port = port
      @state = state
    end

    def get_authentication_token
      raise ArgumentError, "No port specified" if port.nil?
      raise ArgumentError, "No state specified" if state.nil?

      server = TCPServer.open(port) # Socket to listen on specific port

      client = server.accept
      method, path = client.gets.split
      headers = {}
      while line = client.gets.split(" ", 2)
        break if line[0] == ""
        headers[line[0].chop] = line[1].strip
      end
      data = client.read(headers["Content-Length"].to_i)

      results = split_path_components path

      failed = false

      if results["state"].nil? || results["state"] != @state
        client.puts "Unrecognized request. Please try again"
        failed = true
      end

      if results["code"].nil?
        client.puts "Unrecognized request. Please try again"
        failed = true
      end

      unless failed == true
        client.puts "Authorization received. You can close this window now."
      end

      client.close

      results
    end

    def split_path_components path
      raise ArgumentError, "nil path returned from gamewisp" if path.nil?

      vals = path.split('&', 2)
      vals[0].gsub!("/?", "")

      results = {}
      parts = vals[0].split("=", 2)
      results[parts[0]] = parts[1]

      parts = vals[1].split("=", 2)
      results[parts[0]] = parts[1]

      results
    end
  end
end
