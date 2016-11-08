require "gamewisp/version"

module Gamewisp
  class GamewispClientError < StandardError
  end
end

require 'gamewisp/token_store'
require 'gamewisp/authorizer'
require 'gamewisp/server'
require 'gamewisp/client'

