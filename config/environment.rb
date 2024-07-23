# frozen_string_literal: true

# Load the environment ---------------------------------------------------------
ENV['SINATRA_ENV'] ||= 'development'
ENV['RACK_ENV']    ||= 'development'

environment = ENV['RACK_ENV'] || 'development'

# Load gems --------------------------------------------------------------------
require 'bundler/setup'
Bundler.require(:default, ENV['SINATRA_ENV'])

# Configure logging ------------------------------------------------------------
require 'logger'
LOGGER = Logger.new($stdout)

LOGGER.level = case environment
               when 'development'
                 Logger::DEBUG
               when 'production'
                 Logger::WARN
               else
                 Logger::INFO
               end

# Load application code --------------------------------------------------------
require_all 'app'
