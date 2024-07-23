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
LOGGER = Logger.new(STDOUT)

case environment
when 'development'
  LOGGER.level = Logger::DEBUG
when 'production'
  LOGGER.level = Logger::WARN
else
  LOGGER.level = Logger::INFO
end

# Load application code --------------------------------------------------------
require_all 'app'
