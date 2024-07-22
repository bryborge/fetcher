# frozen_string_literal: true

require 'sinatra/json'

# Base controller for API.
class ApiController < Sinatra::Base
  get '/' do
    @user = User.find_or_create_by!(name: 'World')
    json "Hello #{@user.name}"
  end
end
