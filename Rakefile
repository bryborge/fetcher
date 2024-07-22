# frozen_string_literal: true

ENV['SINATRA_ENV'] ||= 'development'

require_relative './config/environment'
require 'sidekiq'
require 'sidekiq/cli'
require 'sinatra/activerecord/rake'

desc 'starts a console'
task :console do
  ActiveRecord::Base.logger = Logger.new($stdout)
  Pry.start
end

desc 'starts sidekiq'
namespace :sidekiq do
  task :work do
    Sidekiq::CLI.instance.run
  end
end
