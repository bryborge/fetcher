# frozen_string_literal: true

require 'sinatra/json'

# Base controller.
class BaseApiController < Sinatra::Base
  before { content_type :json }

  get '/' do
    { message: 'Welcome to the Fetcher API' }.to_json
  end
end
