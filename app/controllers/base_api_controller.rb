# frozen_string_literal: true

require 'sinatra/json'
require 'sinatra/reloader'

# Base controller.
class BaseApiController < Sinatra::Base
  configure :development do
    register Sinatra::Reloader # hot-reload in development
  end

  before { content_type :json }

  get '/' do
    { message: 'Welcome to the Fetcher API' }.to_json
  end
end
