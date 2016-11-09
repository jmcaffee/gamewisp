require "gamewisp/version"

module Gamewisp
  class GamewispClientError < StandardError
  end
end

if ENV["DEBUG"] and ENV["DEBUG"] == "1"
  $DEBUG = true
end

def dbg msg, other = nil
  if $DEBUG
    puts msg
    unless other.nil?
      puts other
    end
  end
end

require 'gamewisp/token_store'
require 'gamewisp/authorizer'
require 'gamewisp/server'
require 'gamewisp/client'

