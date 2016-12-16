require "gamewisp/version"

module Gamewisp
  class GamewispClientError < StandardError
  end

  class << self
    attr_accessor :configuration
    attr_accessor :appname
  end

  def self.system_data_path
    # See [XDG Specs](https://specifications.freedesktop.org/basedir-spec/basedir-spec-0.6.html)
    # for info regarding XDG system directories.
    path = ENV['XDG_DATA_HOME']
    path ||= File.join(Dir.home, '.local', 'share')
  end

  def self.app_data_path(create = false)
    app = Gamewisp.appname
    app ||= "gamewisp_client"

    path = File.join(Gamewisp.system_data_path, app)
    FileUtils.mkdir_p(path) if create
    path
  end

  def self.system_config_path
    path = ENV['XDG_CONFIG_HOME']
    path ||= File.join(Dir.home, '.config')
  end

  def self.app_config_path(create = false)
    app = Gamewisp.appname
    app ||= "Gamewisp Client"

    path = File.join(Gamewisp.system_config_path, app)
    FileUtils.mkdir_p(path) if create
    path
  end

  def self.config_file_path
    File.join(Gamewisp.app_config_path(true), 'gamewisp.config.yml')
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration) if block_given?
  end

  def self.load_configuration cfg_file = nil
    cfg_file ||= Gamewisp.config_file_path

    if File.exist? cfg_file
      @configuration = YAML.load_file(cfg_file)
    end
  end

  def self.save_configuration cfg_file = nil
    cfg_file ||= Gamewisp.config_file_path

    raise ArgumentError, 'Directory provided. Need file path' if File.directory?(cfg_file)

    File.open(cfg_file, 'w') do |out|
      YAML.dump(configuration, out)
    end
  end


  class Configuration
    attr_reader :version

    attr_accessor :app_path
    attr_accessor :logging
    attr_accessor :max_log_size
    attr_accessor :log_dir
    attr_accessor :client_id
    attr_accessor :client_secret
    attr_accessor :endpoint_host
    attr_accessor :endpoint_port

    def initialize
      @version = 1
    end
  end
end # module

Gamewisp.configure do |config|
  config.app_path = Gamewisp.app_data_path
  config.log_dir = config.app_path
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

